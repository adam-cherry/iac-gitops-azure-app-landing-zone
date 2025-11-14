
resource "random_id" "prefix" {
  byte_length = 8
}
resource "random_string" "suffix" {
  length  = 8
  numeric = true
  special = false
  upper   = false
}