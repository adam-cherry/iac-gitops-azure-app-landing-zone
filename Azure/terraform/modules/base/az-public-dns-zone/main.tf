resource "azurerm_dns_zone" "public-dns-zone" {
  name                = var.public_dns_domain_name
  resource_group_name = var.public_dns_zone_resource_group_name
}

resource "azurerm_dns_txt_record" "txt-record" {
  depends_on          = [azurerm_dns_zone.public-dns-zone]
  name                = var.txt_record_name
  zone_name           = azurerm_dns_zone.public-dns-zone.name
  resource_group_name = azurerm_dns_zone.public-dns-zone.resource_group_name
  ttl                 = 3600
  record {
    value = var.txt_record_value
  }
}

resource "azurerm_dns_a_record" "dns_a_record" {
  depends_on          = [azurerm_dns_zone.public-dns-zone]
  for_each            = var.dns_a_records
  name                = each.value.name
  zone_name           = azurerm_dns_zone.public-dns-zone.name
  resource_group_name = var.public_dns_zone_resource_group_name
  ttl                 = 3600
  records             = each.value.records
}