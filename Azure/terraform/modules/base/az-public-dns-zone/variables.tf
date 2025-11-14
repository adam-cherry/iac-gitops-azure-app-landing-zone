variable "public_dns_zone_resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Virtual Network Gateway. Changing this forces a new resource to be created."
}

variable "public_dns_domain_name" {
  type        = string
  description = "(Required) The domain name of this public DNS zone"
}

variable "txt_record_name" {
  type = string
}

variable "txt_record_value" {
  type = string
}

variable "dns_a_records" {
  type = map(object({
    name    = string
    records = list(string)
  }))
  default = null
}