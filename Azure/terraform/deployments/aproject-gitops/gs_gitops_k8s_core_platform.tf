module "gitops_core_platform" {
  source  = "../../modules/core/gitops-k8s-core-platform"

  argo_bootstrap_app_artifact = {
    oci_artifact_version = "01.12.00"
    # TODO: Replace with actual credentials from secure source (e.g., Azure Key Vault, environment variables, or SOPS)
    oci_artifact_login = var.oci_artifact_login #data.sops_file.secrets.data["oci_artifact_login"]
    oci_artifact_password = var.oci_artifact_password #data.sops_file.secrets.data["oci_artifact_password"]
  }

clusters = [
#    {
#    name                   = module.aks_workload.aks_name
#    host                   = data.azurerm_kubernetes_cluster.aks_workload.kube_admin_config.0.host
#    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_workload.kube_admin_config.0.client_certificate)
#    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_workload.kube_admin_config.0.client_key)
#    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_workload.kube_admin_config.0.cluster_ca_certificate)
#    dns_suffix             = "cloudspielwiese.online"
#  }
]

  cloud_provider = "azure"

  platform_config_enabled = false
  platformer_config = "shared-services-values.yaml"
  harbor_enabled =  false
  gitea_enabled =  false
  external_dns_enabled = false

  dns_suffix = "cloudspielwiese.online"

  admin_password = ""

 #Todo: Pipeline / SOPs Encryption Values
  # SECURITY: Do not commit credentials. Use environment variables or secure secret management
  platform_gitops_override = {
    repo_url = "https://example@dev.azure.com/org/project/_git/repo"
    login    = var.gitops_login # TODO: Replace with actual credentials
    password = var.gitops_password # TODO: Replace with actual credentials
  }
}


data "azurerm_kubernetes_cluster" "aks" {
  name                = module.aks_gitops.aks_name
  resource_group_name = azurerm_resource_group.rg_aks.name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}


provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}

# KubeConfig Admin Error 
# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate)
# }

# provider "helm" {
#   kubernetes {
#     host                   = data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.host
#     client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate)
#     client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key)
#     cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate)
#   }
# }


#data "azurerm_kubernetes_cluster" "aks_workload" {
#  name = module.aks_workload.aks_name
#  resource_group_name = module.rg_aks_workload.name
#}

