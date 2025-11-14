terraform {
  required_version = ">=1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~>0.9.2"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "random" {
  # Configuration options
}