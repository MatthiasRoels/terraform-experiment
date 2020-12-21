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

variable "gcp_service_list" {
  description = "List of GCP services to be enabled for a project."
  type        = list(string)
}

variable "network_name" {
  description = "Name of the VPC network"
  type = string
}

variable subnets {
  description = "The list of subnets being created"
  type = list(map(string))
  default = []
}
