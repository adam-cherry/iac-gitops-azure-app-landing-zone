<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.101.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.101.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_dns_a_record.dns_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_txt_record.txt-record](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record) | resource |
| [azurerm_dns_zone.public-dns-zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_a_records"></a> [dns\_a\_records](#input\_dns\_a\_records) | n/a | <pre>map(object({<br>    name    = string<br>    records = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_public_dns_domain_name"></a> [public\_dns\_domain\_name](#input\_public\_dns\_domain\_name) | (Required) The domain name of this public DNS zone | `string` | n/a | yes |
| <a name="input_public_dns_zone_resource_group_name"></a> [public\_dns\_zone\_resource\_group\_name](#input\_public\_dns\_zone\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network Gateway. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_txt_record_name"></a> [txt\_record\_name](#input\_txt\_record\_name) | n/a | `string` | n/a | yes |
| <a name="input_txt_record_value"></a> [txt\_record\_value](#input\_txt\_record\_value) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->