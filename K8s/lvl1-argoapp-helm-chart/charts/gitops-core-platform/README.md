# aproject-k8s-core-platform

![Version: 0.0.75](https://img.shields.io/badge/Version-0.0.75-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.75](https://img.shields.io/badge/AppVersion-0.0.75-informational?style=flat-square)

aproject Platform

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| adminPassword | string | `""` |  |
| argocd.cluster | string | `"https://kubernetes.default.svc"` |  |
| argocd.clusterName | string | `"deployment"` |  |
| argocd.namespace | string | `"argocd"` |  |
| argocd.project | string | `"platform"` |  |
| certManager.chart | string | `"cert-manager"` |  |
| certManager.chartRepo | string | `"https://charts.jetstack.io"` |  |
| certManager.namespace | string | `"cert-manager"` |  |
| certManager.version | string | `"1.15.1"` |  |
| clusterType.deployment | bool | `false` |  |
| clusterType.observability | bool | `false` |  |
| clusterType.workload | bool | `true` |  |
| dnsSuffix | string | `"aproject.internal"` |  |
| externalDns.chart | string | `"external-dns"` |  |
| externalDns.chartRepo | string | `"https://kubernetes-sigs.github.io/external-dns/"` |  |
| externalDns.enabled | bool | `true` |  |
| externalDns.namespace | string | `"external-dns"` |  |
| externalDns.stackit.auth_token | string | `""` |  |
| externalDns.stackit.domain_filter | string | `""` |  |
| externalDns.stackit.project_id | string | `""` |  |
| externalDns.version | string | `"1.14.5"` |  |
| externalSecrets.chart | string | `"external-secrets"` |  |
| externalSecrets.chartRepo | string | `"https://charts.external-secrets.io"` |  |
| externalSecrets.enabled | bool | `true` |  |
| externalSecrets.namespace | string | `"external-secrets"` |  |
| externalSecrets.values | string | `""` |  |
| externalSecrets.version | string | `"v0.9.20"` |  |
| gitea.certManagerIssuer | string | `"letsencrypt-acme-http-staging"` |  |
| gitea.chart | string | `"gitea"` |  |
| gitea.chartRepo | string | `"https://dl.gitea.io/charts"` |  |
| gitea.enabled | bool | `true` |  |
| gitea.namespace | string | `"gitea"` |  |
| gitea.values | string | `""` |  |
| gitea.version | string | `"10.3.0"` |  |
| gitopsRepo | string | `""` |  |
| harbor.certManagerIssuer | string | `"letsencrypt-acme-http-staging"` |  |
| harbor.chart | string | `"harbor"` |  |
| harbor.chartRepo | string | `"https://helm.goharbor.io"` |  |
| harbor.enabled | bool | `true` |  |
| harbor.namespace | string | `"harbor"` |  |
| harbor.registrySize | string | `"5Gi"` |  |
| harbor.updateStrategy | string | `"Recreate"` |  |
| harbor.values | string | `""` |  |
| harbor.version | string | `"1.15.0"` |  |
| ingressNginx.chart | string | `"ingress-nginx"` |  |
| ingressNginx.chartRepo | string | `"https://kubernetes.github.io/ingress-nginx"` |  |
| ingressNginx.enabled | bool | `true` |  |
| ingressNginx.namespace | string | `"ingress-nginx"` |  |
| ingressNginx.values | string | `""` |  |
| ingressNginx.version | string | `"4.11.0"` |  |
| internalLbs | bool | `true` |  |
| ktcPlatformClusterBase.chart | string | `"aproject-k8s-platform-clusters"` |  |
| ktcPlatformClusterBase.chartRepo | string | `"docker--swxt--demo.ext-repo-eu.aprojecttraffic.com"` |  |
| ktcPlatformClusterBase.namespace | string | `"ktc"` |  |
| ktcPlatformClusterBase.version | string | `"0.0.3"` |  |
| kyverno.chart | string | `"kyverno"` |  |
| kyverno.chartRepo | string | `"https://kyverno.github.io/kyverno/"` |  |
| kyverno.enabled | bool | `true` |  |
| kyverno.namespace | string | `"kyverno"` |  |
| kyverno.policies.chart | string | `"kyverno-policies"` |  |
| kyverno.policies.podSecurityStandard | string | `"baseline"` |  |
| kyverno.policies.validationFailureAction | string | `"Audit"` |  |
| kyverno.policies.version | string | `"3.2.5"` |  |
| kyverno.values | string | `""` |  |
| kyverno.version | string | `"3.2.6"` |  |
| platformConfig.config.secretName | string | `"platform-config"` |  |
| platformConfig.image.repository | string | `"ghcr.io/thschue/platformer"` |  |
| platformConfig.image.tag | string | `"dev-202407300820"` |  |
| provider | string | `""` |  |

