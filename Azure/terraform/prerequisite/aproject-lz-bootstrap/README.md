# Overview
This root module is used to set up basic resources needed to run Terraform deployments:
* A container in an Azure Storage account for the Terraform remote state
* An Azure key vault for secret management
* Entra ID App registrations as service principals to run Terraform in DevOps pipelines

This module also contains a Powershell script ([Start-LzBootstrapProcess.ps1](./misc/Start-LzBootstrapProcess.ps1)) to help you set up a service principal for the initial Terraform deployment.

# Pre-Requisites
* Tools
  * Microsoft PowerShell 7.4 (or newer)
  * Azure CLI 2.55.0 (or newer)
* Azure Subscriptions
* Azure Authentication and Permissions

## Tools
### Install Powershell
It is recommende to install PowerShell using WinGet Packet Manager:
```
winget install --id Microsoft.Powershell --source winget
```
Alternatively, you can install it manually, using a MSI package as described at [Installing the MSI package](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#installing-the-msi-package).

### Install Azure CLI
You can use Winget Packet Manager to install and manage updates for Azure CLI:
```
winget install -e --id Microsoft.AzureCLI
```
## Azure Subscriptions
Request Azure subscriptions from aproject IT, using the "[New Azure standalone subscription](https://jira.aproject.net/servicedesk/customer/portal/2/create/115)" form. Have the subscriptions transferred to your project Microsoft Entra tenant and move them below the "Tenant Root" [management group](https://portal.azure.com/#view/Microsoft_Azure_Resources/ManagementGroupBrowseBlade/~/MGBrowse_overview).

You will need at least three subscriptions:
* Management: This is used to deploy the bootstrap and management resources, such as log analytics and automation accounts.
* Identity: This is used to deploy the identity resources, such as Azure AD and Azure AD Domain Services.
* Networking: This is used to deploy the networking resources, such as virtual networks and firewalls.

Take note of the subscription id of each subscription as we will need them later.

## Azure Authentication and Permissions
You need a User with the following permissions to run the bootstrap:
* Owner on your root [management groups](https://portal.azure.com/#view/Microsoft_Azure_Resources/ManagementGroupBrowseBlade/~/MGBrowse_overview) (usually called Tenant Root Group)
  * Owner is required as this account will be granting permissions for the identities that run the management group deployment. Those identities will be granted least privilege permissions.
* Owner on each of your 3 Azure landing zone subscriptions.

### Create Permissions
1. Navigate to the [Azure Portal](https://portal.azure.com/) and sign in to your tenant.
2. Search for [management groups](https://portal.azure.com/#view/Microsoft_Azure_Resources/ManagementGroupBrowseBlade/~/MGBrowse_overview) and open it.
3. Click the `Tenant Root Group`.
4. Open `Access Control (IAM)` in the left navigation.
5. Click `+ Add` and choose `Add role assignment`.
6. Choose the `Privileged administrator roles` tab.
7. Click `Owner` to highlight the row and then click `Next`.
8. Leave the `User, group or service principal` option checked.
9. Click `+ Select Members` and search for your User in the search box on the right.
10. Click on your User to highlight it and then click Select and then click Next.
11. Click the `Allow user to assign all roles (highly privileged)` option.
12. Click `Review + assign`, then click `Review + assign` again when the warning appears.
13. Wait for the role to be assigned

# Run the Start-LzBootstrapProcess script
Create a PowerShell session and run the '[Start-LzBootstrapProcess.ps1](./misc/Start-LzBootstrapProcess.ps1)' script.
The script will then
1. Create an App Registration for your Terraform pipeline
2. Create a Service Principals (SPNs), based on the App registration
3. Grant the Service Principal 'Owner' permission on the Root Management Group
4. Register the needed ResourceProviders in your Azure Subscriptions
5. (Optional) add a Microsoft Partner ID

**Important:** the script's output will display information and secrets needed for Terraform authentication. Use the information to set your environment variables:
```PowerShell
$env:ARM_TENANT_ID="<Project tenant ID>"
$env:ARM_SUBSCRIPTION_ID="<'Management' subscription ID>"
$env:ARM_CLIENT_ID="<Service Principal 'GDE Pipeline L0' client ID>"
$env:ARM_CLIENT_SECRET="<Service Principal 'GDE Pipeline L0' secret>"
```

# Use Terraform bootstrap module
You can use this 'bootstrap' Terraform module to set up
1. An Azure key vault for all backend secrets
2. Different Service Principals for Terraform pipelines (e.g. SPNs for platform landing zone vs. application landing zone management)
3. An Azure storage accounts for Terraform remote backend. **Important:** please be aware, that you have to manually transfer your local state to the storage container. See [Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage).
4. Entra ID security groups