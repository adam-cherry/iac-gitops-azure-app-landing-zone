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
  description = "Azure region where the resources will be deployed"
}

variable "location-secondary" {
  type        = string
  default     = "northeurope"
  description = "Secondary Azure region, for failover (ASR)"
}

variable "resource_tags_default" {
  type        = map(string)
  description = "A map of Tags that will be applied to Azure resources, e.g. 'project' or 'cost-center'."
}

variable "tenant_id" {
  type        = string
  description = "The ID for our Microsoft Entra ID tenant."
}

# LZ identity variables
variable "subscription_id_identity" {
  type        = string
  description = "If specified, identifies the Platform subscription for 'Identity' for resource deployment and correct placement in the Management Group hierarchy."
}

# LZ connectivity variables
variable "subscription_id_connectivity" {
  type        = string
  description = "If specified, identifies the Platform subscription for 'Connectivity' for resource deployment and correct placement in the Management Group hierarchy."
}

# LZ management variables
variable "subscription_id_management" {
  type        = string
  description = "If specified, identifies the Platform subscription for 'Management' for resource deployment and correct placement in the Management Group hierarchy."
}