locals {
  public_dns_zones_list = {
    public_dns_zone_01 = {
      domain_name         = "aproject.pub"
      resource_group_name = "aproject-dns"
      txt_record_name     = "@"
      txt_record_value    = "MS=ms21569766"
      dns_a_records = {
        test = {
          name    = "test"
          records = ["10.10.10.111"]
        }
      }
    }
  }
}