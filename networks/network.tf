module "vpc" {

    source  = "terraform-google-modules/network/google"
    version = "~> 2.6"

    project_id   = var.project_id
    network_name = var.network_name
    routing_mode = "REGIONAL"

    subnets = var.subnets
}

/* NAT config */
resource "google_compute_router" "default_router" {
  name    = "default-router-1"
  project = var.project_id
  region  = var.region
  network = module.vpc.network_self_link

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "default_nat" {
  name                               = "nat-config"
  router                             = google_compute_router.default_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

/* Firewall rules */

//   Ranges for default firewall rules.
data "google_netblock_ip_ranges" "legacy_health_checkers" {
  range_type = "legacy-health-checkers"
}

data "google_netblock_ip_ranges" "health_checkers" {
  range_type = "health-checkers"
}

data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}

/*
  Allow ssh connections from the IAP (Identity Aware Proxy) CIDR block
  This rules will prevent public SSH traffic and only allow authorized traffic
  through IAP
*/
resource "google_compute_firewall" "allow_ingress_from_iap" {
  name    = join("-", [module.vpc.network_name, "allow-ingress-from-iap"])
  network = module.vpc.network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports = [22]

  }

  // Cloud IAP's TCP forwarding netblock
  source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)

  target_tags = ["allow-ingress-from-iap"]
}

/*
Allow traffic for Internal & Global load balancing health check and load balancing IP ranges.
*/
resource "google_compute_firewall" "allow_lb" {
  name    = "lb-healthcheck"
  network = module.vpc.network_name
  project = var.project_id

  source_ranges = concat(data.google_netblock_ip_ranges.health_checkers.cidr_blocks_ipv4, data.google_netblock_ip_ranges.legacy_health_checkers.cidr_blocks_ipv4)

  // Allow common app ports by default.
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }

  target_tags = ["allow-lb"]
}
