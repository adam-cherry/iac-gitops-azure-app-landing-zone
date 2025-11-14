terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "satfstate1bb2"
    container_name       = "tfstate-dev"
    key                  = "aks.dev.tfstate"
  }
}