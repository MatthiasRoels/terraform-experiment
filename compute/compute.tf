resource "google_compute_instance" "vm_instance" {
  name         = "gke-bastion-1"
  machine_type = "e2-micro"
  zone = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = var.subnetwork_name
  }

  tags = ["allow-ingress-from-iap"]  // to associate firewall rule to allow SSH from iap

  // Note: using the above tag,
  // you can access this VM via cloud shell with the following command:
  // $ gcloud compute ssh gke-bastion-1 --tunnel-through-iap
}

data "google_compute_subnetwork" "subnetwork" {
  name       = var.subnetwork_name
  project    = var.project_id
  region     = var.region
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  project_id = var.project_id
  name = "gke-cluster-1"

  kubernetes_version = "latest"
  release_channel = "STABLE"

  logging_service = "logging.googleapis.com/kubernetes"

  // networking
  regional = false

  network = var.network
  subnetwork = var.subnetwork_name

  create_service_account  = true
  enable_private_endpoint = true
  enable_private_nodes    = true

  master_ipv4_cidr_block  = "10.132.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    },
  ]

  // related to nodes
  enable_shielded_nodes = true
  remove_default_node_pool = true
  disable_legacy_metadata_endpoints = true

  node_pools = [
    {
      name = "e2-medium-pool"
      machine_type = "e2-medium"
      min_count = 0
      max_count = 5
      disk_size_gb = 50
      disk_type = "pd-ssd"
      image_type = "COS"
      auto_repair = true
      auto_upgrade = true
      preemptible = false
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]

    e2-medium-pool = {}
  }

  node_pools_metadata = {
    all = {}

    e2-medium-pool = {
      pool = "e2-medium-pool"
    }
  }

  // cluster add-ons
  http_load_balancing = true
  horizontal_pod_autoscaling = true

  cluster_resource_labels = {"resource" = "k8s"}
  description = "GKE cluster which form the foundation of our data platform"
}