resource "google_compute_instance" "vm_instance" {
  name         = "GKE-bastion"
  machine_type = "e2-micro"
  zone = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = var.network-name
    access_config {
    }
  }
}