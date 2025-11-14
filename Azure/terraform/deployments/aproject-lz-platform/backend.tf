terraform {
  backend "azurerm" {
    resource_group_name  = "aproject-tfbootstrap"
    storage_account_name = "aprojectbackendstbqrm"
    container_name       = "tf-state-level1"
    key                  = "aproject-lz-platform.tfstate"
  }
  
}