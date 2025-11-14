terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.101.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.identity,
        azurerm.management
      ]
    }
  }
}