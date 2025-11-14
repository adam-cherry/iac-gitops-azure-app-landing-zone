# General 

variable "application" {
  description = "The application name (e.g., tsp1, tsp2, tsp3)."
  type        = string
}

variable "environment" {
  description = "The environment (e.g., acc, prod, stg)."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}
variable "location_short" {
  description = "The short name of the Azure region."
  type        = string
}

variable "vnet_name" {
  description = "Unique virtual network name."
  type        = string
  default     = "main"
}

variable "dns_servers" {
  type = object({
    dns_servers = list(string)
  })
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

# Networking 

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "subnets" {
  description = "The subnet configurations."
  type = map(object({
    name    = string
    newbits = number
    netnum  = number
  }))
}

variable "enable_tsp_subnet_delegation" {
  description = "Enable delegation for the 'stl' subnet."
  type        = bool
  default     = false
}

variable "network_resource_group" {
  description = "The name of the resource group where network will be placed."
  type        = string
  default     = ""
}

variable "module_resource_groups" {
  description = "A list of names for the resource groups."
  type        = list(string)
  default     = []
}

variable "peered_vnet" {
  description = "The peered virtual network configuration"
  type = object({
    id                  = string
    name                = string
    resource_group_name = string
    subscription_id     = string
  })
  default = null
}

variable "dns_zones" {
  description = "List of Private DNS Zones"
  type = list(object({
    id                   = string
    name                 = string
    resource_group_name  = string
    registration_enabled = bool
  }))
}