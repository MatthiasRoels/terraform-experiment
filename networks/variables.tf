variable "project_id" {
  description = "The project ID to deploy to."
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "europe-west1"
}

variable "network_name" {
  description = "Name of the VPC network"
  type = string
}

variable "subnets" {
  description = "The list of subnets being created"
  type = list(map(string))
  default = []
}