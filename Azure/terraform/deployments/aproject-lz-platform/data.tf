# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.
data "azurerm_client_config" "core" {
  provider = azurerm
}

# Obtain client configuration from the "management" provider
data "azurerm_client_config" "management" {
  provider = azurerm.management
}

# Obtain client configuration from the "connectivity" provider
data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

provider "azurerm" {
  alias           = "app1_dev"
  subscription_id = "a9c24bb4-83dd-4f88-b7a6-0c3200465172"
  features {}
}

# Get the current client configuration from the AzureRM provider
data "azurerm_client_config" "current" {}

data "terraform_remote_state" "azure_lz_foundation" {
  backend = "azurerm"
  config = {
    resource_group_name  = "aproject-tfbootstrap"
    storage_account_name = "aprojectbackendstbqrm"
    container_name       = "tf-state-level1"
    key                  = "azure_lz_foundation.tfstate"
  }
}

data "azurerm_key_vault" "keyvault-vpn-secrets" {
  name                = "aproject-tfbootstrap-kv"
  resource_group_name = "aproject-tfbootstrap"
}

data "azurerm_virtual_network" "hub-germanywestcentral" {
  provider            = azurerm.connectivity
  name                = "aproject-hub-germanywestcentral"
  resource_group_name = "aproject-connectivity-germanywestcentral"
}

# data "azurerm_virtual_network" "mgmt-gwc-mgmt-01-vnet-01" {
#   provider            = azurerm.management
#   name                = "aproject-mgmt-gwc-mgmt-01-vnet-01"
#   resource_group_name = "aproject-mgmt-vnet-rg"
# }

# data "azurerm_virtual_network" "tsp1-acc-gwc-main-vnet-01" {
#   provider            = azurerm.tsp1_acc
#   name                = "aproject-acc-gwc-main-vnet-01"
#   resource_group_name = "tsp1-acc-gwc-network-rg"
# }

# data "azurerm_key_vault_secret" "vpn_shared_key_01_secret" {
#   name         = "vpn-shared-key-polska-01"
#   key_vault_id = data.azurerm_key_vault.keyvault-vpn-secrets.id
# }

