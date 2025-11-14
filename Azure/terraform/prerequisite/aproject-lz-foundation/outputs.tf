output "hub_network" {
  value       = module.connectivity.virtual_network
  description = "Returns the configuration data for all Virtual Networks created by this module."
}

output "connectivity_resource_group" {
  value       = module.connectivity.resource_group
  description = "Returns the configuration data for all Resource Groups created by this module."
}

output "dns_zone" {
  value       = module.connectivity.dns_zone
  description = "Returns the configuration data for all DNS Zones created by this module."
}

output "private_dns_zone" {
  value       = module.connectivity.private_dns_zone
  description = "Returns the configuration data for all DNS Zones created by this module."
}

output "management_groups" {
  value       = module.core.management_group
  description = "Landing zone management groups"
}

output "backup_policy_identity_user" {
  value       = azurerm_user_assigned_identity.backup-policy-identity-user
  description = "Backup policy identity user"
}