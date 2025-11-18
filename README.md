# iac-gitops-azure-app-landing-zone

> **⚠️ ARCHIVED**: This repository is no longer actively maintained. For current best practices on Azure Landing Zones and GitOps automation.

## Overview

A reference implementation demonstrating GitOps platform automation on Azure using Infrastructure-as-Code (IaC). This repository showcases a comprehensive approach to infrastructure and Kubernetes deployment automation using Terraform, ArgoCD, and Helm, following the Azure Landing Zone framework.

**Key Concepts**: This project implements a cloud-native GitOps pattern where infrastructure and application deployments are version-controlled, declarative, and automatically synchronized via Git repositories.

## Architecture
<img width="5727" height="4672" alt="LZ-Gitops-platform Azure Architecture-LZ-GitOps-Platform drawio" src="https://github.com/user-attachments/assets/a99fb6c5-9719-4f0a-ac3a-1c7fc07d1c53" />


This repository demonstrates a **three-tier deployment model**:

### Tier 0: Foundation & Prerequisites
Bootstrap and foundational infrastructure:
- Azure subscription and resource group setup
- Terraform state backend configuration (remote storage)
- Network foundation (VNets, subnets, DNS)
- Basic authentication and identity infrastructure

### Tier 1-2: Core Platform
Core infrastructure and Kubernetes platform layer:
- Landing zone platform resources aligned with Azure Cloud Adoption Framework
- Managed Kubernetes cluster (AKS) provisioning
- ArgoCD deployment for GitOps workflow
- Foundational Kubernetes services (cert-manager, ingress, DNS, security policies)
- 
<img width="1407" height="1067" alt="image-1" src="https://github.com/user-attachments/assets/2ba531f2-7491-4a32-b0d0-20da153974ca" />

### Tier 3: Application Workloads
Business application deployments orchestrated via GitOps:
- Application-specific Helm charts
- Workload-specific configuration
- Continuous deployment via ArgoCD
- 
![image-2](https://github.com/user-attachments/assets/7fc484e9-8b55-431f-bc7f-ddcb5e9536a5)

## Core Technologies

| Technology | Purpose |
|-----------|---------|
| **Terraform** | Infrastructure-as-Code for Azure resource provisioning and management |
| **ArgoCD** | GitOps controller for continuous Kubernetes deployment and reconciliation |
| **Helm** | Kubernetes package management and templating framework |
| **Azure Landing Zone** | Cloud Adoption Framework-based reference architecture for Azure |
| **Kyverno** | Kubernetes policy engine for compliance and security enforcement |
| **cert-manager** | Automated TLS certificate provisioning and management |
| **External-DNS** | Automatic DNS record management for Kubernetes services |
| **Ingress-Nginx** | Kubernetes ingress controller for HTTP/HTTPS routing |

## Repository Structure

```
iac-gitops-azure-app-landing-zone/
├── Azure/
│   └── terraform/
│       ├── modules/                 # Reusable Terraform modules
│       │   ├── base/               # Low-level Azure resources
│       │   ├── core/               # High-level composed modules
│       │   └── rootblock/          # Framework and organizational modules
│       ├── deployments/            # Specific deployment configurations
│       │   └── <deployment-name>/  # Individual deployment instances
│       └── prerequisite/           # Bootstrap infrastructure
├── K8s/
│   ├── lvl1-argoapp-helm-chart/    # GitOps platform Helm charts
│   │   ├── charts/
│   │   │   ├── gitops-core-platform/        # Core platform services
│   │   │   └── gitops-k8s-platform-clusters/ # Multi-cluster configuration
│   │   ├── automation/             # Automation tooling
│   │   └── Taskfile.yml            # Build and deployment tasks
│   └── lvl3-hello-helm/            # Example application Helm chart
├── CLAUDE.md                       # Development guidance for AI assistants
└── docs/                           # Architecture diagrams and documentation
```

## Quick Start

### Prerequisites

- **Azure CLI** - For Azure authentication and resource management
- **Terraform** ~3.106 - Infrastructure-as-Code tool
- **kubectl** - Kubernetes command-line interface
- **Helm** 3.x+ - Kubernetes package manager
- **Task** - Build automation tool (optional but recommended)

### Deploying Infrastructure

```bash
# Navigate to deployment directory
cd Azure/terraform/deployments/<deployment-name>

# Initialize Terraform with backend configuration
terraform init \
  -backend-config="subscription_id=<your-subscription-id>" \
  -backend-config="resource_group_name=<your-rg-name>" \
  -backend-config="storage_account_name=<your-storage-account>"

# Validate configuration
terraform validate

# Plan infrastructure changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan
```

### Deploying Kubernetes Platform

```bash
cd K8s/lvl1-argoapp-helm-chart

# Update Helm chart dependencies
helm dependency update

# Validate Helm charts
helm lint charts/gitops-core-platform

# Build/package Helm charts
helm package charts/gitops-core-platform
```

## Key Concepts

### GitOps Workflow

This implementation follows GitOps principles:

1. **Single Source of Truth**: All infrastructure and application state is defined in Git
2. **Declarative Configuration**: Desired state is declared, not imperative commands
3. **Continuous Reconciliation**: ArgoCD monitors Git and automatically applies changes
4. **Immutable History**: Git provides complete audit trail of all changes

### Remote State Management

Terraform state is stored remotely in Azure Storage Account to support:
- Team collaboration without local state files
- Locking to prevent concurrent modifications
- State encryption at rest
- Centralized state backup

### Module-Based Architecture

Terraform modules provide:
- **Base Modules**: Low-level Azure resources (networks, storage, compute)
- **Core Modules**: Composed modules combining base resources into coherent platform components
- **Reusability**: Consistent, version-controlled infrastructure patterns

## Security Considerations

This reference implementation incorporates security best practices:

- **Secret Management**:
  - Sensitive values managed via environment variables (not committed to Git)
  - Support for external secret stores (Azure Key Vault, SOPS encryption)
  - Backend state stored securely in encrypted cloud storage

- **Access Control**:
  - Role-based access control (RBAC) for Azure resources
  - Service principals for automated authentication
  - Kubernetes RBAC and network policies

- **Policy Enforcement**:
  - Kyverno policies enforce cluster-wide security rules
  - Container image scanning and vulnerability detection
  - Namespace isolation and resource quota enforcement

- **Audit & Compliance**:
  - Immutable Git history for all infrastructure changes
  - Azure Monitor and diagnostic logging
  - Complete audit trails for compliance requirements

## Multi-Cluster Support

The platform architecture supports managing multiple Kubernetes clusters:

- Centralized GitOps control via single ArgoCD instance
- Shared services deployed consistently across clusters
- Cluster-agnostic Helm charts with environment-specific values
- Unified policy enforcement via Kyverno

## Known Limitations

- Repository demonstrates reference patterns and may require customization for production use
- Some example configurations use placeholder values and domain names
- Infrastructure examples are region-specific (update as needed for your environment)

## Contributing & Development

This repository serves as a reference implementation. For development guidance:

- Review Terraform module structure in `Azure/terraform/modules/`
- Helm chart organization in `K8s/lvl1-argoapp-helm-chart/charts/`

## References & Further Reading

- [Azure Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/)
- [Azure Landing Zone Accelerator](https://github.com/Azure/landing-zones-accelerator)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Helm Documentation](https://helm.sh/docs/)
- [Kyverno Policy Examples](https://kyverno.io/docs/writing-policies/)

---

**Status**: Archived/Reference Implementation
**Last Updated**: November 2025



