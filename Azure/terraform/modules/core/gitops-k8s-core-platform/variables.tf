variable "namespace" {
  type    = string
  default = "argocd"
}

variable "argo_bootstrap_app_artifact" {
  type = object({
    oci_artifact_repo_url = optional(string, "gitopsmgmtgwcacrnnub.azurecr.io/helm")
    oci_bootstrap_project = optional(string, "helm")
    oci_artifact_chart    = optional(string, "gitops-core-platform")
    # version to be changed and automised
    oci_artifact_version  = optional(string, "01.01.00")
    oci_artifact_login    = string
    oci_artifact_password = string
  })
}

variable "platform_gitops_override" {
  type = object({
    repo_url = optional(string, "")
    login    = optional(string, "")
    password = optional(string, "")
  })
  default = {}
}


variable "clusters" {
  type = list(object({
    name                   = string
    host                   = string
    cluster_ca_certificate = string
    client_certificate     = string
    client_key             = string
    platform_version       = optional(string, "0.0.75")
    dns_suffix              = string
  }))
}

variable "cloud_provider" {
  type    = string
  default = ""
}

variable "harbor_enabled" {
  type    = bool
  default = true
}

variable "gitea_enabled" {
  type    = bool
  default = true
}

variable "external_dns_enabled" {
  type    = bool
  default = true
}

variable "platform_config_enabled" {
  type    = bool
  default = true
}

variable "ingress_internal" {
  type    = string
  default = true
}

variable "harbor_hostname" {
  type    = string
  default = ""
}

variable "harbor_cert_issuer" {
  type    = string
  default = "letsencrypt-acme-http-staging"
}

variable "gitea_cert_issuer" {
  type    = string
  default = "letsencrypt-acme-http-staging"
}

variable "argo_cert_issuer" {
  type    = string
  default = "letsencrypt-acme-http-staging"
}

variable "oci_registry_size" {
  type    = string
  default = "50Gi"
}

variable "stackit" {
  sensitive = true
  type = object({
    auth_token       = optional(string, "")
    domain_filter    = optional(string, "")
    project_id       = optional(string, "")
    secrets_enabled  = optional(bool, false)
    secrets_username = optional(string, "")
    secrets_password = optional(string, "")
  })
  default = {
    auth_token    = ""
    domain_filter = ""
    project_id    = ""
  }
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "dns_suffix" {
  type    = string
  default = "gitops.pub"
}

variable "dns_suffix_workloads" {
  type    = string
  default = "gitops.pub"
}

variable "platformer_config" {
  type      = string
  sensitive = true
}

variable "cert_manager_enabled" {
  type    = bool
  default = true
}