# Declare the Azure landing zones Terraform module
# and provide the configuration for our BGR TSP environments,
# based on Microsoft's 'Enterprise Scale' landing zone.


# The following module declarations act to orchestrate the
# independently defined module instances for core,
# connectivity and management resources
module "core" {
  source = "./modules/core"

  root_id                          = var.root_id
  root_name                        = var.root_name
  primary_location                 = var.location
  secondary_location               = var.location-secondary
  subscription_id_connectivity     = local.subscription_id_connectivity
  subscription_id_identity         = local.subscription_id_identity
  subscription_id_management       = local.subscription_id_management
  subscription_ids_application_lz  = local.subscription_ids_application_lz
  configure_connectivity_resources = module.connectivity.configuration
  configure_management_resources   = module.management.configuration
  configure_identity_resources     = module.identity.configuration
}

module "management" {
  source = "./modules/management"

  root_id                    = var.root_id
  primary_location           = var.location
  subscription_id_management = local.subscription_id_management
  management_resources_tags  = var.resource_tags_default
  email_security_contact     = var.security_alerts_email_address
  log_retention_in_days      = var.log_retention_in_days
}

module "connectivity" {
  source = "./modules/connectivity"

  root_id                      = var.root_id
  primary_location             = var.location
  secondary_location           = var.location-secondary
  subscription_id_connectivity = local.subscription_id_connectivity
  connectivity_resources_tags  = var.resource_tags_default
  enable_ddos_protection       = var.enable_ddos_protection
  enable_dns_privatelinks      = var.enable_dns_privatelinks
  vnet_hub_connectivity        = var.vnet_hub_connectivity
  vnet_hub_dns_servers         = var.vnet_hub_dns_servers
}

module "identity" {
  source = "./modules/identity"

  root_id                  = var.root_id
  primary_location         = var.location
  subscription_id_identity = local.subscription_id_identity
  identity_resources_tags  = var.resource_tags_default
}


locals {
  subscription_ids_platform_lz = {
    Connectivity = local.subscription_id_connectivity
    Identity     = local.subscription_id_identity
    Management   = local.subscription_id_management
  }

  subscription_ids_application_lz = {
    App1 = [
      "a9c24bb4-83dd-4f88-b7a6-0c3200465172", # Main / sub-app1-dev
    ],
  }

}



# Azure consumption Budget for Management Group 'Platform'

resource "azurerm_consumption_budget_management_group" "platform" {
  for_each            = var.consumption_budget.management_group_amount
  name                = "${var.root_name} ${var.consumption_budget.time_grain} budget"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.root_id}-${each.key}"

  amount     = each.value
  time_grain = var.consumption_budget.time_grain

  time_period {
    start_date = var.consumption_budget.start_date
    end_date   = var.consumption_budget.end_date
  }

  notification {
    enabled        = true
    threshold      = 90.0
    operator       = "EqualTo"
    contact_emails = var.consumption_budget.contact_emails
  }

  notification {
    enabled        = true
    threshold      = 110.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = var.consumption_budget.contact_emails
  }
}


# Managed Identity setup

locals {
  application_lz_mgmtgroup_id    = "/providers/Microsoft.Management/managementGroups/${var.root_id}"
  backup_policy_user_permissions = ["Virtual Machine Contributor", "Backup Contributor", "Disk Backup Reader"]
}

resource "azurerm_resource_group" "managed-identity-rg" {
  provider = azurerm.identity
  name     = "${var.root_id}-ManagedIdentity-rg"
  location = var.location
  tags     = var.resource_tags_default
}

# Identity and permissions for Azure VM/VMSS Backup policy

resource "azurerm_user_assigned_identity" "backup-policy-identity-user" {
  provider            = azurerm.identity
  location            = var.location
  name                = "${var.root_id}-backuppolicy-gwc-id"
  resource_group_name = azurerm_resource_group.managed-identity-rg.name
  tags                = var.resource_tags_default
}

resource "azurerm_role_assignment" "backup-policy-roles" {
  for_each             = toset(local.backup_policy_user_permissions)
  scope                = local.application_lz_mgmtgroup_id
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.backup-policy-identity-user.principal_id
}
