locals {
  backend_network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    ip_rules                   = var.backend_ip_rules
    virtual_network_subnet_ids = var.backend_subnet_ids
  }

  # Blob Contributor for L0 SPN on storage account level
  backend_storage_role_assignments = {
    # role_assignment_1 = {
    #   role_definition_id_or_name       = "Storage Blob Data Contributor"
    #   principal_id                     = module.bootstrap_spn["L0"].spn_object_id
    #   skip_service_principal_aad_check = false
    # }
  }

  # One blob container per level
  backend_containers = {
    blob_container0 = {
      name                  = "tf-state-level0"
      container_access_type = "private"
    }
    blob_container1 = {
      name                  = "tf-state-level1"
      container_access_type = "private"
    }
    blob_container2 = {
      name                  = "tf-state-level2"
      container_access_type = "private"
    }
  }
}
