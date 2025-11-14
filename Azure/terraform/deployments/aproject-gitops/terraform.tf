terraform {
  backend "azurerm" {
    # SECURITY: Configure these values via backend config or environment variables
    # Example: terraform init -backend-config="subscription_id=<value>" ...
    subscription_id      = ""
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = "tf-state-level2"
    key                  = "gitops-mgmt.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.106"
    }
  }
}

# provider "azurerm" {
#   alias           = "Connectivity"
#   subscription_id = var.connectivity_subscription_id # TODO: Configure via variables or environment
#   features {}
# }

# provider "azurerm" {
#   alias           = "Identity"
#   subscription_id = var.identity_subscription_id # TODO: Configure via variables or environment
#   features {}
# }
