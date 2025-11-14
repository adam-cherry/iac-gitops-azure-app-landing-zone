terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.113"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.identity,
        azurerm.management
      ]
    }
  }

  backend "azurerm" {
    resource_group_name  = "aproject-tfbootstrap"
    storage_account_name = "aprojectbackendstbqrm"
    container_name       = "tf-state-level1"
    key                  = "azure_lz_foundation.tfstate"
  }
}

# This provider will be used for the deployment of all "Core resources".
provider "azurerm" {
  features {}
}

# This provider will be used for the deployment of all "Connectivity resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "connectivity"
  subscription_id = local.subscription_id_connectivity
  features {}
}

# This provider will be used for the deployment of all "Identity resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "identity"
  subscription_id = local.subscription_id_identity
  features {}
}

# This provider will be used for the deployment of all "Management resources" to the specified `subscription_id`.
provider "azurerm" {
  alias           = "management"
  subscription_id = local.subscription_id_management
  features {}
}

# Logic to handle 1-3 platform subscriptions as available
locals {
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)
  subscription_id_identity     = coalesce(var.subscription_id_identity, local.subscription_id_management)
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
}
