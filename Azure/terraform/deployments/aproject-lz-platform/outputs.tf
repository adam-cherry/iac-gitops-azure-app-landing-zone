output "mgmt_vnet_subnets" {
  value       = module.mgmt-vnet.subnets
  description = "Returns the subnets data for the mgmt vnet."
}

output "mgmt_vnet_resource_id" {
  value       = module.mgmt-vnet.vnet_id
  description = "Returns the ID of the mgmt vnet resource."
}


output "public_dns_zone_id" {
  value       = module.public-dns-zone-bg-az-tollingservices-eu.public_dns_zone_id
  description = "Returns the ID of the public DNS zone."
}

output "private_dns_zone_id" {
  value       = module.private-dns-zone-01.private_dns_zone_id
  description = "Returns the ID of the private DNS zone."
}

output "private_dns_zone_vnet_links_id" {
  value       = module.private-dns-zone-01.private_dns_zone_id_vnet_links
  description = "Returns the ID of the private DNS zone vnet links."
}