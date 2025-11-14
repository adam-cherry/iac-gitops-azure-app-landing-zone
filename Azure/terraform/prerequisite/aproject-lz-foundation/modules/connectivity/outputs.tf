# Output a copy of configure_connectivity_resources for use
# by the core module instance

output "configuration" {
  description = "Configuration settings for the \"connectivity\" resources."
  value       = local.configure_connectivity_resources
}

output "virtual_network" {
  value = module.alz.azurerm_virtual_network
}

output "resource_group" {
  value = module.alz.azurerm_resource_group
}

output "dns_zone" {
  value = module.alz.azurerm_dns_zone
}

output "private_dns_zone" {
  value = module.alz.azurerm_private_dns_zone
}