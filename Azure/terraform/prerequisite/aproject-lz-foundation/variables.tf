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
  description = "Azure region"
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

variable "vnet_hub_connectivity" {
  type        = string
  description = "The hub virtual network's IP address space in CIDR notation."
}

variable "vnet_hub_dns_servers" {
  type        = list(string)
  description = "The hub virtual network's DNS servers."
  default     = []
}

variable "enable_dns_privatelinks" {
  type        = bool
  default     = false
  description = "Controls whether to create private DNS private links for Azure services."
}

variable "enable_ddos_protection" {
  type        = bool
  default     = false
  description = "Controls whether to create a DDoS Network Protection plan and link to hub virtual networks."
}

# LZ management variables
variable "subscription_id_management" {
  type        = string
  description = "If specified, identifies the Platform subscription for 'Management' for resource deployment and correct placement in the Management Group hierarchy."
}

variable "log_retention_in_days" {
  type        = number
  default     = 30
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
}

variable "security_alerts_email_address" {
  type        = string
  description = "Set a custom value for the security contact email address."
}

# Subscription IDs for Application Landing Zones
variable "subscription_ids_application_lz" {
  type        = map(map(string))
  description = "Am map of applications, stages and subscription-IDs for application landing zones."
  default = {
    APP1 = {
      Dev  = "82390434-bfd9-4962-b06c-576cd74f1486"
    }
  }
}


variable "consumption_budget" {
  type = object({
    start_date              = string
    end_date                = string
    time_grain              = string
    contact_emails          = list(string)
    management_group_amount = map(any)
  })
  description = <<-EOT
    Specify the consumption budget for platform- and application-resources.
    Example:
    start_date     = "2023-01-01T00:00:00Z"
    end_date       = "2025-01-01T00:00:00Z"
    time_grain     = "Monthly"
    contact_emails = ["john.doe@aproject.net"]
    management_group_amount = {
      platform = 10000
      TSP1     = 25000
      TSP2     = 15000
    }
  EOT
}
