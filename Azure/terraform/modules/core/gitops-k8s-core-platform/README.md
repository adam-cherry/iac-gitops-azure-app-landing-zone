# KTC Core Platform Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.15.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.15.0/docs/resources/release) | resource |
| [helm_release.platform_bootstrap](https://registry.terraform.io/providers/hashicorp/helm/2.15.0/docs/resources/release) | resource |
| [kubernetes_secret.bootstrap_oci](https://registry.terraform.io/providers/hashicorp/kubernetes/2.32.0/docs/resources/secret) | resource |
| [kubernetes_secret.clusters](https://registry.terraform.io/providers/hashicorp/kubernetes/2.32.0/docs/resources/secret) | resource |
| [kubernetes_secret.platform_config](https://registry.terraform.io/providers/hashicorp/kubernetes/2.32.0/docs/resources/secret) | resource |
| [kubernetes_secret.vault-configuration-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.32.0/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | n/a | `string` | n/a | yes |
| <a name="input_argo_bootstrap_app_artifact"></a> [argo\_bootstrap\_app\_artifact](#input\_argo\_bootstrap\_app\_artifact) | n/a | <pre>object({<br>    oci_artifact_repo_url = optional(string, "docker--swxt--demo.ext-repo-eu.aprojecttraffic.com")<br>    oci_bootstrap_project = optional(string, "default")<br>    oci_artifact_chart    = optional(string, "aproject-k8s-core-platform")<br>    oci_artifact_version  = optional(string, "0.0.75")<br>    oci_artifact_login    = string<br>    oci_artifact_password = string<br>  })</pre> | n/a | yes |
| <a name="input_argo_cert_issuer"></a> [argo\_cert\_issuer](#input\_argo\_cert\_issuer) | n/a | `string` | `"letsencrypt-acme-http-staging"` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | n/a | `string` | `"stackit"` | no |
| <a name="input_clusters"></a> [clusters](#input\_clusters) | n/a | <pre>list(object({<br>    name                   = string<br>    host                   = string<br>    cluster_ca_certificate = string<br>    client_certificate     = string<br>    client_key             = string<br>    platform_version       = optional(string, "0.0.75")<br>  }))</pre> | n/a | yes |
| <a name="input_dns_suffix"></a> [dns\_suffix](#input\_dns\_suffix) | n/a | `string` | `"aproject.internal"` | no |
| <a name="input_dns_suffix_workloads"></a> [dns\_suffix\_workloads](#input\_dns\_suffix\_workloads) | n/a | `string` | `"aproject.internal"` | no |
| <a name="input_gitea_cert_issuer"></a> [gitea\_cert\_issuer](#input\_gitea\_cert\_issuer) | n/a | `string` | `"letsencrypt-acme-http-staging"` | no |
| <a name="input_harbor_cert_issuer"></a> [harbor\_cert\_issuer](#input\_harbor\_cert\_issuer) | n/a | `string` | `"letsencrypt-acme-http-staging"` | no |
| <a name="input_harbor_hostname"></a> [harbor\_hostname](#input\_harbor\_hostname) | n/a | `string` | `""` | no |
| <a name="input_ingress_internal"></a> [ingress\_internal](#input\_ingress\_internal) | n/a | `string` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"argocd"` | no |
| <a name="input_oci_registry_size"></a> [oci\_registry\_size](#input\_oci\_registry\_size) | n/a | `string` | `"50Gi"` | no |
| <a name="input_platformer_config"></a> [platformer\_config](#input\_platformer\_config) | n/a | `string` | n/a | yes |
| <a name="input_stackit"></a> [stackit](#input\_stackit) | n/a | <pre>object({<br>    auth_token       = optional(string, "")<br>    domain_filter    = optional(string, "")<br>    project_id       = optional(string, "")<br>    secrets_enabled  = optional(bool, false)<br>    secrets_username = optional(string, "")<br>    secrets_password = optional(string, "")<br>  })</pre> | <pre>{<br>  "auth_token": "",<br>  "domain_filter": "",<br>  "project_id": ""<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_values"></a> [values](#output\_values) | n/a |
<!-- END_TF_DOCS -->