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
  name    = "default_router"
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

/*
  Allow ssh connections from the IAP (Identity Aware Proxy) CIDR block
  This rules will prevent public SSH traffic and only allow authorized traffic
  through IAP
*/
resource "google_compute_firewall" "allow_iap_tcp_forwarding" {
  name    = "allow-iap-tcp-forwarding"
  network = module.vpc.network_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports = [22]

  }
  # IAP CIDR block
  source_ranges = ["35.235.240.0/20"]
}