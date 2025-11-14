locals {
  aproject = {
    dns_zone_resource_group_name = "aproject-dns"
    private_dns_zone             = "aproject.priv"
    private_dns_zones_vnet_links = {
      private_dns_zone_02 = {
        name                  = "aproject-hub-vnetlink"
        resource_group_name   = "aproject-dns"
        private_dns_zone_name = "aproject.priv"
        virtual_network_id    = data.azurerm_virtual_network.hub-germanywestcentral.id
        auto_registration     = false
      }
    }
  }
}