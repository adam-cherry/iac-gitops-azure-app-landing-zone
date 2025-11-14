# Use variables to customize the deployment

variable "root_id" {
  type        = string
  description = "Sets the value used for generating unique resource naming within the module."
}

variable "primary_location" {
  type        = string
  description = "Sets the location for \"primary\" resources to be created in."
}

variable "secondary_location" {
  type        = string
  description = "Sets the location for \"secondary\" resources to be created in."
}

variable "subscription_id_connectivity" {
  type        = string
  description = "Subscription ID to use for \"connectivity\" resources."
}

variable "enable_ddos_protection" {
  type        = bool
  description = "Controls whether to create a DDoS Network Protection plan and link to hub virtual networks."
}

variable "enable_dns_privatelinks" {
  type        = bool
  description = "Controls whether to create private DNS private links for Azure services."
}

variable "connectivity_resources_tags" {
  type        = map(string)
  description = "Specify tags to add to \"connectivity\" resources."
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
