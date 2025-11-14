resource "azurerm_private_dns_zone" "bgr-tollingservices-eu" {
  name                = var.private_dns_zone
  resource_group_name = var.private_dns_zone_resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "bgr-tollingservices-eu-vnet-links" {
  depends_on            = [azurerm_private_dns_zone.bgr-tollingservices-eu]
  for_each              = var.private_dns_zone_vnet_links
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = each.value.private_dns_zone_name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = each.value.auto_registration
}

resource "azurerm_private_dns_a_record" "dns-record" {
  for_each            = var.private_dns_zone_dns_records
  name                = each.key
  zone_name           = azurerm_private_dns_zone.bgr-tollingservices-eu.name
  resource_group_name = azurerm_private_dns_zone.bgr-tollingservices-eu.resource_group_name
  ttl                 = 3600
  records             = each.value
}