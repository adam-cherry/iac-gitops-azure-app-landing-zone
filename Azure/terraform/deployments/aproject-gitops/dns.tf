# AKS DNS Zone configuration
resource "azurerm_resource_group" "rg_dns" {
  name     = "rg-dns-${var.environment}"
  location = var.location
  tags     =  var.resource_tags_default
}

resource "azurerm_dns_zone" "public_zone" {
  name                = "cloudspielwiese.online"
  resource_group_name = azurerm_resource_group.rg_dns.name
  tags                = var.resource_tags_default
}

resource "azurerm_dns_a_record" "argo" {
  name                = "argo"
  zone_name           = azurerm_dns_zone.public_zone.name
  resource_group_name = azurerm_resource_group.rg_dns.name
  ttl                 = 300
  records             = ["98.67.221.20"]  # Die externe IP Ihres NGINX Ingress Load Balancers

  depends_on = [ azurerm_dns_zone.public_zone ]
}

resource "azurerm_dns_a_record" "hello" {
  name                = "hello"
  zone_name           = azurerm_dns_zone.public_zone.name
  resource_group_name = azurerm_resource_group.rg_dns.name
  ttl                 = 300
  records             = ["98.67.221.20"]  # Die externe IP Ihres NGINX Ingress Load Balancers

  depends_on = [ azurerm_dns_zone.public_zone ]
}

# resource "azurerm_dns_cname_record" "www" {
#   name                = "www"
#   zone_name           = azurerm_dns_zone.public_zone.name
#   resource_group_name = azurerm_resource_group.rg_dns.name
#   ttl                 = 300
#   record              = "cloudspielwiese.online"
# }