# Networking
resource "azurerm_resource_group" "network" {
  name     = var.network_resource_group != "" ? var.network_resource_group : "${local.naming_prefix}-network-rg"
  location = var.location
  tags     = var.tags
}
resource "azurerm_resource_group" "module_resource_groups" {
  count    = length(var.module_resource_groups)
  name     = "${local.naming_prefix}-${var.module_resource_groups[count.index]}-rg"
  location = var.location
  tags     = var.tags
}
resource "azurerm_network_security_group" "vnet_nsg" {
  name                = "${local.naming_prefix}-vnet-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags
  depends_on          = [azurerm_resource_group.network]
}
resource "azurerm_route_table" "vnet_route_table" {
  name                = "${local.naming_prefix}-vnet-rt"
  location            = var.location
  resource_group_name = azurerm_resource_group.network.name
  tags                = var.tags
  route {
    name                   = "default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.next_hop_ip
  }
  depends_on = [azurerm_resource_group.network]
}
module "vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "0.2.3"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  address_space       = var.vnet_address_space
  name                = "${local.naming_prefix}-${var.vnet_name}-vnet-01"
  subnets = {
    for subnet_name, subnet_config in var.subnets : "${subnet_name}-snet" => {
      name             = "${subnet_name}-snet"
      address_prefixes = [cidrsubnet(var.vnet_address_space[0], subnet_config.newbits, subnet_config.netnum)]
      network_security_group = {
        id = azurerm_network_security_group.vnet_nsg.id
      }
      route_table = {
        id = azurerm_route_table.vnet_route_table.id
      }
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
  }
  dns_servers = var.dns_servers
  tags        = var.tags
  depends_on = [
    azurerm_network_security_group.vnet_nsg,
    azurerm_route_table.vnet_route_table
  ]
}
module "postgres_subnet" {
  source               = "claranet/subnet/azurerm"
  version              = "7.0.0"
  custom_subnet_name   = "${local.naming_prefix}-postgres-snet"
  count                = var.enable_tsp_subnet_delegation ? 1 : 0
  environment          = var.environment
  location_short       = var.location_short
  client_name          = var.application
  stack                = "network"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = module.vnet.name
  subnet_cidr_list     = local.subnet_cidr_list
  service_endpoints    = ["Microsoft.Storage"]
  subnet_delegation = {
    postgresql-flexible = [
      {
        name    = "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    ]
  }
  route_table_name            = azurerm_route_table.vnet_route_table.name
  route_table_rg              = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
  network_security_group_rg   = azurerm_resource_group.network.name
  depends_on                  = [module.vnet]
}
module "aci_subnet" {
  source               = "claranet/subnet/azurerm"
  version              = "7.0.0"
  custom_subnet_name   = "${local.naming_prefix}-aci-snet"
  count                = var.enable_tsp_subnet_delegation ? 1 : 0
  environment          = var.environment
  location_short       = var.location_short
  client_name          = var.application
  stack                = "network"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = module.vnet.name
  subnet_cidr_list     = [cidrsubnet(var.vnet_address_space[0], 8, 12)]
  # Todo: Delete Service Endpoint, not working in Delegation Subnet
  #service_endpoints = ["Microsoft.Storage"]
  subnet_delegation = {
    aci = [
      {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    ]
  }
  route_table_name            = azurerm_route_table.vnet_route_table.name
  route_table_rg              = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.vnet_nsg.name
  network_security_group_rg   = azurerm_resource_group.network.name
  depends_on                  = [module.vnet]
}
resource "azurerm_virtual_network_peering" "vnet_peering" {
  count                        = var.peered_vnet != null ? 1 : 0
  name                         = "${module.vnet.resource.name}-to-hub-vnet-peering"
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = module.vnet.resource.name
  remote_virtual_network_id    = var.peered_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [module.vnet]
}

resource "azurerm_virtual_network_peering" "peer_vnet_peering" {
  count                        = var.peered_vnet != null ? 1 : 0
  name                         = "${var.peered_vnet.name}-to-${module.vnet.name}-vnet-peering"
  resource_group_name          = var.peered_vnet.resource_group_name
  virtual_network_name         = var.peered_vnet.name
  remote_virtual_network_id    = module.vnet.resource.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  provider                     = azurerm.dns
  depends_on                   = [module.vnet]
}
# Link private DNS zones to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each              = { for zone in var.dns_zones : zone.name => zone }
  name                  = "${local.naming_prefix}-vlink-${each.value.name}"
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = module.vnet.resource_id
  registration_enabled  = each.value.registration_enabled
  provider              = azurerm.dns
}