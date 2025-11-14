# Logic to handle 1-3 platform subscriptions as available
locals {
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)
  subscription_id_identity     = coalesce(var.subscription_id_identity, local.subscription_id_management)
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
}