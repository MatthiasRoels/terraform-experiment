terraform {
  required_version = ">= 0.12"
}

provider "google" {
  project     = var.project_id
}

# Enable services in newly created GCP Project.
resource "google_project_service" "gcp_services" {
  count   = length(var.gcp_service_list)
  project = var.project_id
  service = var.gcp_service_list[count.index]

  disable_dependent_services = true
}

module "networks" {
  source = "./networks"
  project_id = var.project_id
  region = var.region
  network_name = var.network_name
  subnets = var.subnets
}

module "compute" {
  source = "./compute"
  zone = var.zone
  network_name = var.network_name
}
