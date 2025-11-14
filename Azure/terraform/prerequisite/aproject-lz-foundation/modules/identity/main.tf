# Configure Terraform to set the required AzureRM provider
# version and features{} block
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
  subscription_id = var.subscription_id_identity
}

# Get the current client configuration from the AzureRM provider
data "azurerm_client_config" "current" {}

# Declare the Azure landing zones Terraform module
# and provide the connectivity configuration.
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

  # Disable creation of the core management group hierarchy
  # as this is being created by the core module instance
  deploy_core_landing_zones = false

  # Configuration settings for identity resources
  deploy_identity_resources    = true
  configure_identity_resources = local.configure_identity_resources
  subscription_id_identity     = var.subscription_id_identity
}
