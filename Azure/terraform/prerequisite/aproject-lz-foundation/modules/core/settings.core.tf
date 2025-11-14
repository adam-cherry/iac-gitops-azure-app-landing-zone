locals {
  custom_landing_zones = {
    "${var.root_id}-App1" = {
      display_name               = "App1"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = var.subscription_ids_application_lz["App1"]
      archetype_config = {
        archetype_id   = "bgrtsp" #Todo: Change to "online" not custom archetype
        parameters     = {}
        access_control = {}
      }
    }
  }
}
