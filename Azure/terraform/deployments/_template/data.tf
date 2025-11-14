# Remote state lookup for managing common resource tags
# data "terraform_remote_state" "backend" {
#   backend = "azurerm"
#   config = {
#     resource_group_name  = "rg-terraform-state"
#     storage_account_name = "satfstatevqq4"
#     container_name       = "tfstate-backend"
#     key                  = "backend.tfstate"
#   }
# }
