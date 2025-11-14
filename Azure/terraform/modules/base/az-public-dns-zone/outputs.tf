output "public_dns_zone_id" {
  description = "The ID of the public DNS zone."
  value       = azurerm_dns_zone.public-dns-zone.id
}