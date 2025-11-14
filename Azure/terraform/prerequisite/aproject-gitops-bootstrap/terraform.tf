terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "aproject-tfbootstrap"
  #   storage_account_name = "aprojectbackendstbqrm"
  #   container_name       = "tf-state-level0"
  #   key                  = "backend.tfstate"
  # }
}

# This provider will be used for the deployment of all "bootstrap resources".
provider "azurerm" {
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_key_vaults            = true
    }
  }
  subscription_id = var.subscription_id_management
}

# This provider will be used to configure Microsoft Entra groups and settings for the project tenant `tenant_id`.
provider "azuread" {
  tenant_id = var.tenant_id
}
