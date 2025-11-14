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