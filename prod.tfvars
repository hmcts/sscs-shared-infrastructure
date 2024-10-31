tribunals_frontend_external_hostname = "www.appeal-benefit-decision.service.gov.uk"

external_cert_vault_uri               = "https://infra-vault-prod.vault.azure.net/"
tribunals_frontend_external_cert_name = "core-compute-prod"

#================================================================================================
# Azure Monitor
#================================================================================================
monitor_action_group = {
  "sscs-prod-dead-letter" = {
    short_name = "sscsDeadLet"
    email_receiver = [
      {
        email_receiver_name = "SSCS Alerts"
      }
    ]
  }
}


monitor_metric_alerts = {
  "sscs-prod-dead-letter-alerts" = {
    window_size = "PT5M"
    frequency   = "PT5M"
    criteria = [
      {
        metric_namespace = "Microsoft.ServiceBus/namespaces"
        metric_name      = "DeadletteredMessages"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 0
        dimension = [
          {
            name     = "EntityName"
            operator = "Include"
            values   = ["tribunals-to-hearing-api-prod"]
          }
        ]
      }
    ]
    action = [
      {
        module_name = "sscs-ci-slack-action-group"
      }
    ]
  }
  "sscs-prod-inflight-messages-alert" = {
    window_size = "PT5M"
    frequency   = "PT5M"
    criteria = [
      {
        metric_namespace       = "Microsoft.ServiceBus/namespaces"
        metric_name            = "ActiveMessages"
        aggregation            = "Total"
        operator               = "GreaterThan"
        threshold              = 100
        skip_metric_validation = false
        dimension = [
          {
            name     = "EntityName"
            operator = "Include"
            values   = ["sscs-evidenceshare-topic-prod"]
          }
        ]
      }
    ]
    action = [
      {
        module_name = "sscs-ci-slack-action-group"
      }
    ]
  }

}

sftp_allowed_key_secrets = ["sftp-user-pub-key", "sftp-gaps2-pub-key"]
sftp_access_AAD_objectId = "8e672e21-2c69-45ec-a07f-a135cfc103e7" // dcd_sc_reform_sscs

sftp_allowed_sa_subnets = [
  // Jenkins agents
  "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/cft-ptl-network-rg/providers/Microsoft.Network/virtualNetworks/cft-ptl-vnet/subnets/iaas",
  "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/cft-ptl-network-rg/providers/Microsoft.Network/virtualNetworks/cft-ptl-vnet/subnets/aks-00",
  "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/cft-ptl-network-rg/providers/Microsoft.Network/virtualNetworks/cft-ptl-vnet/subnets/aks-01",

  // AKS workloads
  "/subscriptions/8cbc6f36-7c56-4963-9d36-739db5d00b27/resourceGroups/cft-prod-network-rg/providers/Microsoft.Network/virtualNetworks/cft-prod-vnet/subnets/iaas",
  "/subscriptions/8cbc6f36-7c56-4963-9d36-739db5d00b27/resourceGroups/cft-prod-network-rg/providers/Microsoft.Network/virtualNetworks/cft-prod-vnet/subnets/aks-00",
  "/subscriptions/8cbc6f36-7c56-4963-9d36-739db5d00b27/resourceGroups/cft-prod-network-rg/providers/Microsoft.Network/virtualNetworks/cft-prod-vnet/subnets/aks-01",

  // VPN Access
  "/subscriptions/ed302caf-ec27-4c64-a05e-85731c3ce90e/resourceGroups/rg-mgmt/providers/Microsoft.Network/virtualNetworks/core-infra-vnet-mgmt/subnets/sub-vpn-outside"
]

max_message_size_in_kilobytes = 5120

service_bus_sku = "Premium"

capacity = 1

zone_redundant = true
