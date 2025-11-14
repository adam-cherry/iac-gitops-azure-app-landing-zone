output "aks_name" {
  value       = module.aks[0].aks_name
  description = "The `azurerm_kubernetes_cluster`'s name."
}

output "aks_id" {
  value       = module.aks[0].aks_id
  description = "The `azurerm_kubernetes_cluster`'s id."
}