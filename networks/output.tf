output "network-name" {
  value = module.vpc.metwork_name
  description = "The name of the VPC network"
}

output "network_self_link" {
  value = module.vpc.network_self_link
  description = "The URI of the VPC network"
}

output "subset_names" {
  value = module.vpc.subset_names
  description = "The names of the subnets being created"
}

output "subset_ips" {
  value = module.vpc.subset_ips
  description = "The IPs and CIDRs of the subnets"
}

output "subnets_self_link" {
  value = module.vpc.subnets_self_link
  description = "The self-links of the subnets"
}

output "subset_regions" {
  value = module.vpc.subset_regions
  description = "The regions where the subnets are created"
}

output "subnets_private_access" {
  value = module.vpc.subnets_private_access
  description = "Whether the subnets have access to Google API's without a public IP"
}

output "subnets_flow_logs" {
  value = module.vpc.subnets_flow_logs
  description = "Whether the subnets have VPC flow logs enabled"
}

output "subnets_secondary_ranges" {
  value = module.vpc.subnets_secondary_ranges
  description = "The secondary ranges associated with the subnets"
}