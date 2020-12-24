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

  tags = ["allow-ingress-from-iap"]
}