variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "europe-west1-b"
}

variable "subnetwork_name" {
  description = "Name of the VPC subnetwork"
  type = string
}