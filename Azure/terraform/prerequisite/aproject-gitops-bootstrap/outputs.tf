output "backend_storage_account_name" {
  description = "Name of the backend storage account"
  value       = module.bootstrap-storageaccount.name
}

output "backend_storage_account_id" {
  description = "Id of the backend storage account"
  value       = module.bootstrap-storageaccount.id
}

output "backend_storage_containers" {
  description = "Backend storage containers, where the tfstates are located"
  value = {
    for k, v in azurerm_storage_container.containers : k => {
      name                  = v.name
      storage_account_name  = v.storage_account_name
      container_access_type = v.container_access_type
      resource_manager_id   = v.resource_manager_id
    }
  }
  sensitive = false
}

output "backend_keyvault_uri" {
  description = "URI of the backend key vault"
  value       = module.bootstrap-keyvault.uri
}

output "backend_keyvault_id" {
  description = "Name of the backend key vault"
  value       = module.bootstrap-keyvault.resource_id
}

# output "azuread_group_aksadmins_displayname" {
#   description = "Display name for the AKS admin group"
#   value       = azuread_group.groups["AKSAdmins"].display_name
# }

# output "azuread_group_aksadmins_objectid" {
#   description = "Object id for the AKS admin group"
#   value       = azuread_group.groups["AKSAdmins"].object_id
# }

output "resource_default_tags" {
  description = "A map of Tags that will be applied to Azure resources."
  value       = var.resource_tags_default
}

output "tenant_id" {
  description = "The Azure Tenant ID."
  value       = var.tenant_id
}

output "subscription_id" {
  description = "The ID for the core/management Azure subscription."
  value       = var.subscription_id_management
}

output "root_id" {
  description = "The project's root id."
  value       = var.root_id
}

output "location" {
  description = "The project's primary Azure location."
  value       = var.location
}

output "location_secondary" {
  description = "The project's secondary Azure location."
  value       = var.location_secondary
}
