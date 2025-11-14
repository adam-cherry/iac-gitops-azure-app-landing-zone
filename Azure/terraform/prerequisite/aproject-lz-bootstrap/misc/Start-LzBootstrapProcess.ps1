[CmdletBinding()]
param (
    [string]$TenantId = "3fd104df-e8fc-4246-b748-84588a4cc165",
    [string]$SubscriptionIdIdentity = "d35c3d66-5d44-48fb-a06e-ac9bc27c41d2",
    [string]$SubscriptionIdManagement = "2a232e0c-e5e5-42c0-bf38-4f6f883a22fa",
    [string]$SubscriptionIdConnectivity = "ce84f480-a362-4da0-ad6a-c2d71c7fe685",
    [Int32]$MsPartnerId = 6076522, # Microsoft Partner ID
    [bool]$UseCurrentAzAuthentication = $true, # Use the current PowerShell session authentication to Azure (Connect-AzAccount)
    [bool]$UseCurrentMgAuthentication = $true, # Use the current PowerShell session authentication to Microsoft Graph (Connect-MgGraph)
    [string]$SpLogoFile = "./Terraform-Icon.png"
)


# ########## ########## ##########
# Authentication to Azure and Microsoft Graph
$MsGraphScopes = @(
    "Group.ReadWrite.All",
    "Application.ReadWrite.All"
)

if (-not $UseCurrentAzAuthentication) {
    Connect-AzAccount -Tenant $TenantId
}

if (-not $UseCurrentMgAuthentication) {
    Connect-MgGraph -TenantId $TenantId -NoWelcome -Scopes $MsGraphScopes
}

# ########## ########## ##########
# Create Entra ID Service Principals
$ServicePrincipal = @{
    DisplayName = "GDE Pipeline L0"
    Notes       = "SPN for Terraform pipeline `"Level 0`": Terraform State, LZ Management Groups (MG), Entra ID groups and billing."
}
$AppSignInAudience = "AzureADMyOrg"
$AppPasswordCredential = @{ displayName = 'Terraform secret' }
$SpnLevel0Role = "Owner"

# Create App Registration
$App = Get-MgApplication -Filter "DisplayName eq '$($ServicePrincipal.DisplayName)'"
if ($null -eq $App) {
    $App = New-MgApplication -DisplayName $ServicePrincipal.DisplayName -Notes $ServicePrincipal.Notes -SignInAudience $AppSignInAudience

    # Add Terraform logo to application
    if (Test-Path -Path $SpLogoFile) {
        Set-MgApplicationLogo -ApplicationId $App.Id -InFile $SpLogoFile
    }

    # Add random application secret
    $AppSecret = Add-MgApplicationPassword -applicationId $App.Id -PasswordCredential $AppPasswordCredential

    Write-Information "Created App Registration '$($App.DisplayName)' [$($App.Id)]"
    Write-Host "Use environment variables for Terraform authentication:"
    Write-Host "`$env:ARM_TENANT_ID=`"$TenantId`""
    Write-Host "`$env:ARM_SUBSCRIPTION_ID=`"$SubscriptionIdManagement`""
    Write-Host "`$env:ARM_CLIENT_ID=`"$($App.AppId)`""
    Write-Host "`$env:ARM_CLIENT_SECRET=`"$($AppSecret.SecretText)`""
}
else {
    Write-Information "App Registration '$($App.DisplayName)' [$($App.Id)] already exists"
}

# Create ServicePrincipal for App
$Spn = Get-MgServicePrincipal -Filter "AppId eq '$($App.AppId)'" -ConsistencyLevel eventual
if ($null -eq $Spn) {
    $Spn = New-MgServicePrincipal -AppId $App.AppId -Notes $ServicePrincipal.Notes
    Write-Information "Created ServicePrincipal '$($Spn.DisplayName)' [$($Spn.Id)]"
}
else {
    Write-Information "ServicePrincipal '$($Spn.DisplayName)' [$($Spn.Id)] already exists"
}

# Create Role Assignments for L0 Service Principal on Root Management Group
$RootManagementGroup = Get-AzManagementGroup -GroupName $TenantId
$OwnerRoleAssignment = Get-AzRoleAssignment -Scope $RootManagementGroup.Id -RoleDefinitionName $SpnLevel0Role -ObjectId $Spn.Id
if ($null -eq $OwnerRoleAssignment) {
    New-AzRoleAssignment -Scope $RootManagementGroup.Id -RoleDefinitionName $SpnLevel0Role -ObjectId $Spn.Id
    Write-Host "Created '$SpnLevel0Role' Role Assignment for $($App.DisplayName) [$($App.Id)] on $($RootManagementGroup.DisplayName)"
}
else {
    Write-Information "'$SpnLevel0Role' Role Assignment for $($App.DisplayName) [$($App.Id)] already exists on $($RootManagementGroup.DisplayName)"
}


# ########## ########## ##########
# Enable Azure Resource provider for
# Landing Zone subscriptions
Set-AzContext -Subscription $SubscriptionIdIdentity
Register-AzResourceProvider -ProviderNamespace "Microsoft.AzureActiveDirectory"


# ########## ########## ##########
# Set Microsoft Partner ID (if available)
if ($null -ne $MsPartnerId) {
    Install-Module Az.ManagementPartner

    if ($null -eq (Get-AzManagementPartner -ErrorAction SilentlyContinue)) {
        New-AzManagementPartner -PartnerId $MsPartnerId
    }
    else {
        Update-AzManagementPartner -PartnerId $MsPartnerId
    }
}