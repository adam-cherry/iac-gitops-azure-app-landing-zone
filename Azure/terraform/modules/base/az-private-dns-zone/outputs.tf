output "private_dns_zone_id" {
  description = "The ID of the private zone."
  value       = azurerm_private_dns_zone.bgr-tollingservices-eu.id
}

output "private_dns_zone_id_vnet_links" {
  description = "The IDs of the private zone vnet links."
  value       = azurerm_private_dns_zone_virtual_network_link.bgr-tollingservices-eu-vnet-links
}