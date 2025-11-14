# # AKS (Azure Kubernetes Services) resources for GitOps workload

# # Base resource group


# resource "azurerm_resource_group" "rg_aks_workload" {
#   name     = replace("rg-workloadaks-${local.env}-${var.location_abbreviation}", "--", "-")
#   location = var.location
#   tags     = var.resource_tags_default
# }



# module "aks_workload" {
#   source  = "../../modules/core/az-kubernetes"


#   resource_group_name = azurerm_resource_group.rg_aks.name
#   location            = azurerm_resource_group.rg_aks.location
#   location_short      = var.location_abbreviation
#   application         = "aproject"
#   environment         = "dev"

#   vnet_subnet_id                  = module.app_subnet.subnet_id
#   rbac_aad_admin_group_object_ids = local.rbac_aad_admin_group_object_ids
#   admin_username                  = "azureadmin"
#   k8s_private_dns_zone_id         = azurerm_dns_zone.public_zone.id #Public DNS

#   node_pools = {
#     app1 = {
#       name                = "app1"
#       vm_size             = "Standard_D2s_v5" # 2 vCPU, 8 GB Memory
#       node_count          = 3
#       os_disk_size_gb     = 256
#       enable_auto_scaling = false
#       min_count           = null
#       max_count           = null
#       max_pods            = 110
#     }
#   }

#   depends_on = [time_sleep.wait_30_seconds]
# }
