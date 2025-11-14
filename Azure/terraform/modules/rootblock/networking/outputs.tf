output "vnet_id" {
  description = "The ID of the virtual network."
  value       = module.vnet.resource_id
}

output "vnet_resource_group_name" {
  description = "The name of the resource group containing the virtual network."
  value       = azurerm_resource_group.network.name
}

output "subnet_ids" {
  description = "A map of subnet names and their corresponding IDs."
  value = {
    for subnet_name, subnet_config in var.subnets : "${subnet_name}-snet" => module.vnet.subnets["${subnet_name}-snet"].resource_id
  }
}

output "delegation_postgres_subnet_id" {
  description = "The ID of the virtual network."
  value       = var.enable_tsp_subnet_delegation ? module.postgres_subnet[0].subnet_id : null
}

output "delegation_aci_subnet_id" {
  description = "The ID of the virtual network."
  value       = var.enable_tsp_subnet_delegation ? module.aci_subnet[0].subnet_id : null
}


output "subnets" {
  description = "A map of subnets that have been created."
  value       = module.vnet.subnets
}

# bspw. module.networking.subnet_ids["app"]

output "resource_group_names" {
  description = "A map of resource group names created by the module."
  value = {
    network = azurerm_resource_group.network.name
    module  = { for i, name in var.module_resource_groups : name => azurerm_resource_group.module_resource_groups[i].name }
  }
}
# bspw. module.networking.resource_group_names["module"]