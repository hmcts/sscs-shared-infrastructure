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
        action_group_name = "sscs-prod-dead-letter"
      }
    ]
  }
}

sftp_allowed_key_secrets = ["sftp-user-pub-key", "sftp-gaps2-pub-key"]
sftp_access_AAD_objectId = "8e672e21-2c69-45ec-a07f-a135cfc103e7" // dcd_sc_reform_sscs
sftp_allowed_sa_subnets = [
  "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/cft-ptl-network-rg/providers/Microsoft.Network/virtualNetworks/cft-ptl-vnet/subnets/iaas" // Jenkins subnet
]
