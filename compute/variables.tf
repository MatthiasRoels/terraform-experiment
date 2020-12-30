variable "project_id" {
  description = "The project ID to deploy to."
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "europe-west1-b"
}

variable "network" {
  description = "Name of the VPC network"
  type = string
}

variable "subnetwork_name" {
  description = "Name of the VPC subnetwork"
  type = string
}