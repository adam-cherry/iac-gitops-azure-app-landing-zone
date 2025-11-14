locals {
  naming_prefix    = "${var.application}-${var.environment}-${var.location_short}"
  next_hop_ip      = "10.70.0.4"
  subnet_cidr_list = [cidrsubnet(var.vnet_address_space[0], 8, 7)]
}
