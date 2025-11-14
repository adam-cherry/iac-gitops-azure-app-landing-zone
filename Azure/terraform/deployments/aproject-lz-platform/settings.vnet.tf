# Define Firewall Policy Rule Colletion Group(s) here
locals {
  hub_network       = values(data.terraform_remote_state.azure_lz_foundation.outputs.hub_network.connectivity)[0]
  private_dns_zones = data.terraform_remote_state.azure_lz_foundation.outputs.private_dns_zone.connectivity
  dns_zones_base = [
    for zone in local.private_dns_zones : {
      id                   = zone.id
      name                 = zone.name
      resource_group_name  = zone.resource_group_name
      registration_enabled = false
    }
  ]
  aproject_priv_dns_zone = {
    id                   = module.private-dns-zone-01.private_dns_zone_id
    name                 = local.aproject.private_dns_zone
    resource_group_name  = local.aproject.dns_zone_resource_group_name
    registration_enabled = true
  }
  dns_zones                      = (contains(local.dns_zones_base, local.aproject_priv_dns_zone ) == false ? concat(local.dns_zones_base, [local.aproject_priv_dns_zone ]) : local.dns_zones_base)
  mgmt-vnet = {
    application                   = var.root_id
    name                          = "mgmt-vnet"
    environment                   = "mgmt"
    location_short                = "gwc"
    network_resource_group        = "aproject-mgmt-vnet-rg"
    vnet_name                     = ""
    virtual_network_address_space = ["10.70.16.0/20"]
    subnets = {
      MgmtVNetSubnet01 = {
        name    = "MgmtVNetSubnet01"
        newbits = 4
        netnum  = 0
        ##  address_prefixes = ["10.70.16.0/24"]
      }
    }
    peered_vnet = {
      id                  = local.hub_network.id
      name                = local.hub_network.name
      resource_group_name = local.hub_network.resource_group_name
      subscription_id     = split("/", local.hub_network.id)[2]
    }
    dns_servers = {
      dns_servers = [] #"10.70.0.4" f.Ex. Private DNS Resolver
    }
  }
}