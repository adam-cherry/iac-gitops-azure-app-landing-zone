# Configure the connectivity resources settings.
locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = [var.vnet_hub_connectivity]
            location                     = var.primary_location
            link_to_ddos_protection_plan = var.enable_ddos_protection
            dns_servers                  = var.vnet_hub_dns_servers
            subnets                      = []
            virtual_network_gateway = {
              enabled = false
              config  = {}
            }
            azure_firewall = {
              enabled = false
              config = {
                address_prefix                = cidrsubnet(var.vnet_hub_connectivity, 4, 1) # First subnet in our Hub VNet
                enable_dns_proxy              = true
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = {}
                availability_zones = {
                  zone_1 = true
                  zone_2 = true
                  zone_3 = true
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = true
            enable_hub_network_mesh_peering         = false
          }
        }
      ]
      vwan_hub_networks = []
      ddos_protection_plan = {
        enabled = var.enable_ddos_protection
        config = {
          location = var.primary_location
        }
      }
      dns = {
        enabled = var.enable_dns_privatelinks
        config = {
          location = null
          enable_private_link_by_service = {
            azure_api_management                 = true
            azure_app_configuration_stores       = true
            azure_arc                            = false
            azure_automation_dscandhybridworker  = false
            azure_automation_webhook             = true
            azure_backup                         = true
            azure_batch_account                  = false
            azure_bot_service_bot                = false
            azure_bot_service_token              = false
            azure_cache_for_redis                = true
            azure_cache_for_redis_enterprise     = false
            azure_container_registry             = true
            azure_cosmos_db_cassandra            = false
            azure_cosmos_db_gremlin              = false
            azure_cosmos_db_mongodb              = true
            azure_cosmos_db_sql                  = false
            azure_cosmos_db_table                = false
            azure_data_explorer                  = false
            azure_data_factory                   = true
            azure_data_factory_portal            = true
            azure_data_health_data_services      = false
            azure_data_lake_file_system_gen2     = false
            azure_database_for_mariadb_server    = false
            azure_database_for_mysql_server      = false
            azure_database_for_postgresql_server = true
            azure_digital_twins                  = false
            azure_event_grid_domain              = false
            azure_event_grid_topic               = false
            azure_event_hubs_namespace           = false
            azure_file_sync                      = false
            azure_hdinsights                     = false
            azure_iot_dps                        = false
            azure_iot_hub                        = false
            azure_key_vault                      = true
            azure_key_vault_managed_hsm          = true
            azure_kubernetes_service_management  = true
            azure_machine_learning_workspace     = true
            azure_managed_disks                  = true
            azure_media_services                 = false
            azure_migrate                        = false
            azure_monitor                        = true
            azure_purview_account                = false
            azure_purview_studio                 = false
            azure_relay_namespace                = false
            azure_search_service                 = false
            azure_service_bus_namespace          = false
            azure_site_recovery                  = true
            azure_sql_database_sqlserver         = false
            azure_synapse_analytics_dev          = false
            azure_synapse_analytics_sql          = false
            azure_synapse_studio                 = false
            azure_web_apps_sites                 = false
            azure_web_apps_static_sites          = false
            cognitive_services_account           = false
            microsoft_power_bi                   = false
            signalr                              = false
            signalr_webpubsub                    = false
            storage_account_blob                 = true
            storage_account_file                 = true
            storage_account_queue                = false
            storage_account_table                = false
            storage_account_web                  = false
          }
          private_link_locations = [
            var.primary_location,
            var.secondary_location,
          ]
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
          virtual_network_resource_ids_to_link                   = []
        }
      }
    }

    location = var.primary_location
    tags     = var.connectivity_resources_tags
    advanced = null
  }
}
