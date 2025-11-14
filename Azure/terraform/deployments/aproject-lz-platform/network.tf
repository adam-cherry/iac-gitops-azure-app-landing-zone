# Extract values from the "Landing Zone foundation" remote state
locals {
  resource_group_name         = values(data.terraform_remote_state.azure_lz_foundation.outputs.connectivity_resource_group.connectivity)[0].name
  virtual_network_name        = values(data.terraform_remote_state.azure_lz_foundation.outputs.hub_network.connectivity)[0].name
  virtual_network_resource_id = values(data.terraform_remote_state.azure_lz_foundation.outputs.hub_network.connectivity)[0].id
  vnet_address_space          = values(data.terraform_remote_state.azure_lz_foundation.outputs.hub_network.connectivity)[0].address_space[0]
}


# Create a Virtual Network (VNet) in our
# 'Management' subscription
module "mgmt-vnet" {
  source = "../../modules/rootblock/networking"
  providers = {
    azurerm     = azurerm.management
    azurerm.dns = azurerm.connectivity
  }
  location               = var.location
  application            = local.mgmt-vnet.application
  environment            = local.mgmt-vnet.environment
  location_short         = local.mgmt-vnet.location_short
  vnet_name              = local.mgmt-vnet.vnet_name
  network_resource_group = local.mgmt-vnet.network_resource_group
  vnet_address_space     = local.mgmt-vnet.virtual_network_address_space
  subnets                = local.mgmt-vnet.subnets
  dns_servers            = local.mgmt-vnet.dns_servers
  peered_vnet            = local.mgmt-vnet.peered_vnet
  tags                   = var.resource_tags_default
  dns_zones              = local.dns_zones_base # local.dns_zones
}

# Create a Private DNS Zone 'aproject.priv'
# and link it to our VNets
module "private-dns-zone-01" {
  source = "../../modules/base/az-private-dns-zone"
  providers = {
    azurerm = azurerm.connectivity
  }
  private_dns_zone_resource_group_name = local.aproject.dns_zone_resource_group_name
  private_dns_zone                     = local.aproject.private_dns_zone
  private_dns_zone_vnet_links          = local.aproject.private_dns_zones_vnet_links
}


# Create a Public DNS Zone 'aproject.pub'
module "public-dns-zone-bg-az-tollingservices-eu" {
  source = "../../modules/base/az-public-dns-zone"
  providers = {
    azurerm = azurerm.connectivity
  }
  public_dns_zone_resource_group_name = local.public_dns_zones_list.public_dns_zone_01.resource_group_name
  public_dns_domain_name              = local.public_dns_zones_list.public_dns_zone_01.domain_name
  txt_record_name                     = local.public_dns_zones_list.public_dns_zone_01.txt_record_name
  txt_record_value                    = local.public_dns_zones_list.public_dns_zone_01.txt_record_value
  dns_a_records                       = local.public_dns_zones_list.public_dns_zone_01.dns_a_records
}


