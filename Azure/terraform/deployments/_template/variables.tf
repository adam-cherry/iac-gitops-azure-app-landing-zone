variable "location" {
  description = "Azure cloud computing region"
  type        = string
}
variable "prefix" {
  description = "Prefix for the resources"
  type        = string
}

variable "resource_group" {
  description = "Resource group name where the resources will be deployed"
  type        = string
}