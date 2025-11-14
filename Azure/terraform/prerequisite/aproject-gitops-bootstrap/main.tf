# Resource group for bootstrap resources
resource "azurerm_resource_group" "backend" {
  location = var.location
  name     = "${var.root_id}-tfbootstrap"
  tags     = var.resource_tags_default
}

locals {
  backend_lock = { name = "Do not delete bootstrap resources", kind = "CanNotDelete" } # Resource lock configuration
}


# Backend KeyVault, used for Service Principal secrets
# Based on AVM https://github.com/Azure/terraform-azurerm-avm-res-keyvault-vault
module "bootstrap-keyvault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.7.3"

  resource_group_name = azurerm_resource_group.backend.name
  name                = lower("${var.root_id}-tfboot-kv")
  location            = var.location
  tenant_id           = var.tenant_id
  tags                = var.resource_tags_default
  lock                = var.lock_resources ? local.backend_lock : {}
  role_assignments    = local.backend_keyvault_role_assignments
  sku_name            = local.backend_keyvault_sku

  network_acls = local.backend_keyvault_network_acls

  soft_delete_retention_days = 30

  depends_on = [azurerm_resource_group.backend]
}

# # SPNs for Terraform pipelines
# module "bootstrap_spn" {
#   for_each = var.backend_levels
#   source   = "../../modules/base/az-serviceprincipal"

#   app_display_name             = "${each.value.prefix} ${each.key}"
#   app_notes                    = "SPN for Terraform pipeline '${each.key}': ${each.value.description}"
#   app_logo_path                = "./misc/Terraform-Icon.png"
#   app_owners                   = [data.azurerm_client_config.current.object_id]
#   app_required_resource_access = each.value.required_resource_access == null ? [] : each.value.required_resource_access

#   key_vault_id = module.bootstrap-keyvault.resource_id

#   depends_on = [module.bootstrap-keyvault]
# }



# Bootstrap storage, used for Terraform remote backend
# Based on AMV https://github.com/Azure/terraform-azurerm-avm-res-storage-storageaccount
module "bootstrap-storageaccount" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.1.1"

  resource_group_name = azurerm_resource_group.backend.name
  name                = lower("${var.root_id}backendsa")
  location            = var.location
  tags                = var.resource_tags_default
  lock                = var.lock_resources ? local.backend_lock : {}
  role_assignments    = local.backend_storage_role_assignments

  network_rules                 = local.backend_network_rules
  public_network_access_enabled = true # scoped to allowed IP addresses and VNet
  #containers                    = local.backend_containers #DNS Error switch to own ressource

  shared_access_key_enabled     = true

  depends_on = [azurerm_resource_group.backend]
}

resource "azurerm_storage_container" "containers" {
  for_each = local.backend_containers 

  name                  = each.value.name
  storage_account_name  = module.bootstrap-storageaccount.name
  container_access_type = each.value.container_access_type
}

# # Entra Groups
# resource "azuread_group" "groups" {
#   for_each = var.security_groups

#   display_name     = "${var.root_id}-AU-${each.key}"
#   description      = each.value
#   owners           = [data.azurerm_client_config.current.object_id]
#   security_enabled = true
# }
