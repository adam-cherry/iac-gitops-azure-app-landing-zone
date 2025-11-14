# General landing zone variables
variable "root_id" {
  type        = string
  description = "If specified, will set a custom Name (ID) value for the Enterprise-scale 'root' Management Group, and append this to the ID for all core Enterprise-scale Management Groups."
}

variable "root_name" {
  type        = string
  description = "If specified, will set a custom Display Name value for the Enterprise-scale 'root' Management Group."
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Azure region (primary)"
}

variable "location_secondary" {
  type        = string
  default     = "northeurope"
  description = "Azure region (secondary)"
}

variable "resource_tags_default" {
  type        = map(string)
  description = "A map of Tags that will be applied to Azure resources, e.g. 'project' or 'cost-center'."
}

variable "tenant_id" {
  type        = string
  description = "The ID for our Microsoft Entra ID tenant."
}

variable "subscription_id_management" {
  type        = string
  description = "If specified, identifies the Platform subscription for 'Management' for resource deployment and correct placement in the Management Group hierarchy."
}

variable "backend_levels" {
  type = map(object({
    prefix      = string
    description = string
    required_resource_access = optional(list(object({
      resource_app_id = string
      resource_access = list(object({
        id   = string
        type = string
      }))
    })))
  }))
  default = {
    L0 = {
      prefix      = "GDE Pipeline",
      description = "Terraform State, LZ Management Groups (MG) and billing"

      # Grant the L0 Service Principal "Application.ReadWrite.OwnedBy" and "Directory.ReadWrite.All" permission for Microsoft Graph
      required_resource_access = [{
        resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
        resource_access = [{
          id   = "18a4783c-866b-4cc7-a460-3d5e5662c884" # Application.ReadWrite.OwnedBy
          type = "Role"
          },
          {
            id   = "19dbc75e-c2e2-444c-a770-ec69d8559fc7" # Directory.ReadWrite.All
            type = "Role"
        }]
      }]
    }
    L1 = { prefix = "GDE Pipeline", description = "Platform Landing zone" },
    L2 = { prefix = "GDE Pipeline", description = "Application Landing zones" }
  }
  description = <<EOT
    Backend_levels is used to generate storage containers and service principals for use in Terraform (pipelines) to separate permissions for different
    Landingzone areas, for example "Platform LZ" vs. "Application LZ".
    'Level 0' (bootstrap) also needs MS Graph permission "Application.ReadWrite.OwnedBy" to create and update Entra App Registrations and Service Principals.
  EOT
}

variable "lock_resources" {
  type        = bool
  default     = true
  description = "Create 'Do not Delete' locks on resources."
}

variable "backend_ip_rules" {
  type        = list(string)
  description = "A list of IP addresses that may access the terraform remote backend storage account."
}

variable "backend_subnet_ids" {
  type        = list(string)
  description = "A list of Subnet IDs that may access the terraform remote backend storage account."
  default     = []
}

variable "security_groups" {
  type        = map(string)
  description = "(Optional) A map of names and descriptions for Entra ID security groups used for this project's operations model."
  default     = null
}