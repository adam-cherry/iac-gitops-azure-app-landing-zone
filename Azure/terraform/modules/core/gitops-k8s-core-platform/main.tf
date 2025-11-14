resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  version          = "7.4.4"
  wait             = true
  atomic           = true
  create_namespace = true
  values = [
    templatefile("${path.module}/templates/argo_server_values.yaml", {
      dns_suffix      = var.dns_suffix
      cert_issuer     = var.argo_cert_issuer
      # secrets_enabled = var.stackit.secrets_enabled  --> missing inside the template file
      # provider        = var.cloud_provider  --> missing inside the template file
  })]
}

resource "helm_release" "platform_bootstrap" {
  name       = "argocd-bootstrap"
  chart      = "argocd-apps"
  atomic     = true
  wait       = true
  repository = "https://argoproj.github.io/argo-helm"

  values = [
    templatefile("${path.module}/templates/argocd_app.yaml.tpl", {
      artifact_repo_url  = var.argo_bootstrap_app_artifact.oci_artifact_repo_url
      artifact_chart     = var.argo_bootstrap_app_artifact.oci_artifact_chart
      artifact_version   = var.argo_bootstrap_app_artifact.oci_artifact_version
      app_name           = "platform-bootstrap"
      namespace          = helm_release.argocd.namespace
      cluster_name       = "deployment"
      cluster_endpoint   = "https://kubernetes.default.svc"
      deployment_cluster = "true"
      ingress_internal   = var.ingress_internal
      provider           = var.cloud_provider
      stackit            = var.stackit
      ## TODO: Create Secret for this
      admin_password       = var.admin_password
      dns_suffix           = var.dns_suffix
      dns_suffix_workloads = var.dns_suffix_workloads
      internal_lbs         = var.ingress_internal
      registry_size        = var.oci_registry_size
      harbor_cert_issuer   = var.harbor_cert_issuer
      harbor_url           = var.harbor_hostname
      gitea_cert_issuer    = var.gitea_cert_issuer
      harbor_enabled       = var.harbor_enabled
      gitea_enabled        = var.gitea_enabled
      platform_gitops_repo_url = var.platform_gitops_override.repo_url
      platform_gitops_password = var.platform_gitops_override.password
      platform_gitops_login =  var.platform_gitops_override.login     
      platform_config_enabled = var.platform_config_enabled
      external_dns_enabled = var.external_dns_enabled
      cert_manager_enabled = var.cert_manager_enabled
    })
  ]

  # depends_on = [
  #   kubernetes_secret.bootstrap_oci
  # ]
}

output "values" {
  value = helm_release.platform_bootstrap.values
}


resource "kubernetes_secret" "bootstrap_oci" {
  metadata {
    labels = {
      "argocd.argoproj.io/secret-type" = "repository",
    }
    namespace = helm_release.argocd.namespace
    name      = "gitops-argo-oci-bootstrap"
  }
  data = {
    "enableOCI" = "true"
    "username"  = var.argo_bootstrap_app_artifact.oci_artifact_login
    "password"  = var.argo_bootstrap_app_artifact.oci_artifact_password
    "type"      = "helm"
    "url"       = var.argo_bootstrap_app_artifact.oci_artifact_repo_url
    "project"   = var.argo_bootstrap_app_artifact.oci_bootstrap_project
  }

  depends_on = [
    helm_release.argocd
  ]
}

resource "kubernetes_secret" "argo_cred_template" {
  metadata {
    name      = "gitops-argo-cred-oci-bootstrap"
    namespace = helm_release.argocd.namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    "enableOCI" = "true"
    "username"  = var.argo_bootstrap_app_artifact.oci_artifact_login
    "password"  = var.argo_bootstrap_app_artifact.oci_artifact_password
    "type"      = "helm"
    "url"       = var.argo_bootstrap_app_artifact.oci_artifact_repo_url
    "project"   = var.argo_bootstrap_app_artifact.oci_bootstrap_project
  }

  depends_on = [
    helm_release.argocd
  ]
}

resource "kubernetes_secret" "clusters" {
  count = length(var.clusters)
  metadata {
    name = "argocd-cluster-${var.clusters[count.index].name}"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
    annotations = {
      "aproject.net/platform-version" = var.clusters[count.index].platform_version
    }
    namespace = helm_release.argocd.namespace
  }
  data = {
    "name"   = var.clusters[count.index].name
    "server" = var.clusters[count.index].host
    "dnssuffix" = var.clusters[count.index].dns_suffix
    "config" = <<EOT
{"tlsClientConfig": {"certData": "${var.clusters[count.index].client_certificate}","keyData": "${var.clusters[count.index].client_key}","insecure":true}}
EOT
  }
}

#Todo: Update DNS 

resource "kubernetes_secret" "platform_config" {
  metadata {
    name      = "platform-config"
    namespace = helm_release.argocd.namespace
  }
  binary_data = {
    "platformer.yaml" = var.platformer_config
  }
}

resource "kubernetes_secret" "vault-configuration-secret" {
  count = var.stackit.secrets_enabled ? 1 : 0
  metadata {
    name      = "vault-configuration"
    namespace = helm_release.argocd.namespace
  }

  data = {
    VAULT_ADDR = "https://prod.sm.eu01.stackit.cloud"
    AVP_TYPE : "vault"
    AVP_AUTH_TYPE : "userpass"
    AVP_USERNAME = var.stackit.secrets_username
    AVP_PASSWORD = var.stackit.secrets_password
  }
}
