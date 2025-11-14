# iac-gitops-azure-app-landing-zone

> **⚠️ DEPRECATED**: This repository is no longer actively maintained. For current best practices and updated implementations, please refer to the official [Azure Landing Zone Accelerator](https://github.com/Azure/landing-zones-accelerator) and the conceptual foundation in our blog post below.

## Overview

GitOps platform automation in Azure using Infrastructure-as-Code (IaC), Kubernetes, and CI/CD automation. This repository demonstrates a comprehensive approach to automating cloud infrastructure deployment using Terraform, ArgoCD, and Helm.

### Reference Materials

For a detailed understanding of the concepts and architecture behind this automation platform, please read our blog post:

**[GitOps Plattform Automatisierung in Azure](https://evoila.de/blog)** by Adam Kirschstein (March 21, 2025)

This article covers:
- The fundamentals of GitOps and why it matters
- Azure Landing Zone principles and architecture
- End-to-end automation strategies
- Concrete business benefits and real-world results

## Architecture

This repository implements a **three-level deployment pattern**:

### Level 0: Prerequisites
Bootstrap infrastructure required before main deployments:
- Core Azure resources and subscriptions
- Terraform backend state storage setup
- Initial GitOps infrastructure
- On-premises connectivity setup

### Level 1-2: Core Platform
Main infrastructure and Kubernetes platform:
- Landing zone platform resources
- Network gateways (VPN, bastion, etc.)
- GitOps cluster and ArgoCD setup
- Kubernetes core platform services via Helm charts

### Level 3: Applications
Workload deployments and business applications

## Key Technologies

- **Terraform**: Infrastructure-as-Code for Azure resource provisioning
- **ArgoCD**: GitOps continuous deployment controller for Kubernetes
- **Helm**: Kubernetes package management and templating
- **Azure Landing Zone**: Cloud Adoption Framework-based infrastructure blueprint
- **Kubernetes Platform Services**:
  - ArgoCD: Declarative GitOps deployments
  - Cert-Manager: Automated TLS certificate management
  - External-DNS: Automatic DNS record creation
  - Ingress-Nginx: Kubernetes ingress controller
  - Kyverno: Policy enforcement for security and compliance
  - Harbor: Container image registry with scanning
  - Gitea: Internal Git repository backend

## Repository Structure

```
├── Azure/
│   └── terraform/
│       ├── modules/              # Reusable Terraform modules
│       │   ├── base/            # Low-level Azure resources
│       │   ├── core/            # High-level composition modules
│       │   └── rootblock/       # Framework modules
│       └── deployments/         # Deployment configurations
│           ├── aproject-lz-foundation/
│           ├── aproject-lz-bootstrap/
│           └── aproject-gitops/
├── K8s/
│   └── lvl1-argoapp-helm-chart/  # Main Helm charts
│       └── charts/
│           ├── gitops-core-platform/
│           └── gitops-k8s-platform-clusters/
└── CICD/
    └── platformer-main/          # Go-based provisioning tool
```

## Getting Started

### Prerequisites

- Azure CLI for Azure authentication
- Terraform ~3.106 for Azure provider
- kubectl for Kubernetes cluster access
- Helm for Kubernetes package management
- Go 1.22+ (for platformer tool)
- Task runner (optional but recommended)

### Terraform Deployment

```bash
# Navigate to deployment directory
cd Azure/terraform/deployments/aproject-gitops

# Initialize Terraform with backend configuration
terraform init -backend-config="subscription_id=<value>" \
               -backend-config="resource_group_name=<value>" \
               -backend-config="storage_account_name=<value>"

# Validate configuration
terraform validate

# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan
```

### Kubernetes Platform Deployment

```bash
cd K8s/lvl1-argoapp-helm-chart

# Update Helm dependencies
helm dependency update

# Lint charts
helm lint charts/gitops-core-platform

# Package charts
helm package charts/gitops-core-platform
```

### CI/CD Platform (Platformer)

```bash
cd CICD/platformer-main

# Build the tool
go build -o platformer ./cmd/...

# Run provisioning
go run ./cmd/... [command]
```

## Important Configuration

### Terraform Backend
- **State Storage**: Azure Storage Account (`agitopsbackendsa`)
- **Location**: `Azure/terraform/deployments/aproject-gitops/terraform.tf`
- **Note**: Configure backend values via environment variables or `-backend-config` flags, not in code

### Kubernetes Values
- **Path**: `K8s/lvl1-argoapp-helm-chart/charts/gitops-core-platform/values.yaml`
- **Scope**: Configures all core platform services (ingress, TLS, DNS, registry settings)

### CI/CD Configuration
- **Path**: `CICD/platformer-main/config.yaml`
- **Manages**: Gitea and Harbor provisioning, repository structures, container registry replication

## Security Best Practices

This repository follows security best practices including:

- **Remote State Management**: Terraform state stored in Azure Storage Account, not locally
- **Secret Management**:
  - Credentials managed via environment variables
  - SOPS encryption for GitOps workflow
  - Azure Key Vault integration for secret storage
- **Access Control**:
  - Role-based access control (RBAC) via Azure and Kubernetes
  - Service principals for automated authentication
- **Policy Enforcement**: Kyverno policies ensure:
  - No untagged images (`latest` tags prohibited)
  - Namespace isolation
  - Resource limits and health probes
- **Audit & Compliance**:
  - Complete Git history for all infrastructure changes
  - Azure Monitor and Log Analytics for logging
  - Immutable audit trails

## Multi-Cluster Support

The platform supports multi-cluster Kubernetes deployments:
- Centralized ArgoCD for multi-cluster management
- Shared services deployed once, reused across clusters
- Kyverno policies enforced globally
- Consistent platform experience across all clusters

## Limitations and Known Issues

- Repository is deprecated and no longer actively maintained
- Some configuration references legacy lab environment (`lab.on-clouds.at`)
- Update these references for production deployments

## Contributing

This repository is archived. For contributions to modern Azure landing zone implementations, please see the official Microsoft resources.

## Support & Further Reading

For the conceptual foundation and best practices, refer to:
- The accompanying blog post: **GitOps Plattform Automatisierung in Azure**
- [Microsoft Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/)
- [Azure Landing Zone Accelerator](https://github.com/Azure/landing-zones-accelerator)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

**Last Updated**: November 2025
**Status**: Archived/Deprecated
