variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "europe-west1-b"
}

variable "network_name" {
  description = "Name of the VPC network"
  type = "string"
}