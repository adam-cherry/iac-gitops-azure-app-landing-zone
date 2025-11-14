# Configure Terraform to set the required AzureRM provider
# version and features{} block.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.113"
    }
  }
}

# Define the provider configuration
provider "azurerm" {
  features {}
}

# Get the current client configuration from the AzureRM provider.
data "azurerm_client_config" "current" {}

# Declare the Azure landing zones Terraform module
# and provide the core configuration.
module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "5.2.1"

  default_location = var.primary_location

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  # Base module configuration settings
  root_parent_id = data.azurerm_client_config.current.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.module}/lib"

  # Enable creation of the core management group hierarchy
  # and additional custom_landing_zones
  deploy_core_landing_zones = true
  custom_landing_zones      = local.custom_landing_zones

  # Configuration settings for identity resources is
  # bundled with core as no resources are actually created
  # for the identity subscription
  deploy_identity_resources    = false
  configure_identity_resources = var.configure_identity_resources
  subscription_id_identity     = var.subscription_id_identity

  # The following inputs ensure that managed parameters are
  # configured correctly for policies relating to connectivity
  # resources created by the connectivity module instance and
  # to map the subscription to the correct management group,
  # but no resources are created by this module instance
  deploy_connectivity_resources    = false
  configure_connectivity_resources = var.configure_connectivity_resources
  subscription_id_connectivity     = var.subscription_id_connectivity

  # The following inputs ensure that managed parameters are
  # configured correctly for policies relating to management
  # resources created by the management module instance and
  # to map the subscription to the correct management group,
  # but no resources are created by this module instance
  deploy_management_resources    = false
  configure_management_resources = var.configure_management_resources
  subscription_id_management     = var.subscription_id_management
}


# Policy exemption 'Subnet without NSG' for custom Application LZ
resource "azurerm_management_group_policy_exemption" "subnet_nsg_exemption" {
  for_each = local.custom_landing_zones

  name                 = "Deny-Subnet-Without-Nsg-exemption"
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${each.key}"
  policy_assignment_id = "/providers/microsoft.management/managementgroups/${lower(each.value.parent_management_group_id)}/providers/microsoft.authorization/policyassignments/deny-subnet-without-nsg"
  exemption_category   = "Waiver"
}
