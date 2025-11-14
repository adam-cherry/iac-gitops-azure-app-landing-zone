variable "private_dns_zone" {
  type        = string
  description = "(Required) The name of the private DNS zone."
}

variable "private_dns_zone_resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Virtual Network Gateway. Changing this forces a new resource to be created."
}

variable "private_dns_zone_vnet_links" {
  type = map(object({
    name                  = optional(string)
    resource_group_name   = optional(string)
    private_dns_zone_name = optional(string)
    virtual_network_id    = optional(string)
    auto_registration     = optional(bool)
  }))
}

variable "private_dns_zone_dns_records" {
  type = map(list(string))
  description = "(Optional) DNS Zones to be created."
  default     = {}
}