tribunals_frontend_external_hostname = "sscs-tribunals-frontend-aat.service.core-compute-aat.internal"

external_cert_vault_uri               = "https://infra-vault-nonprod.vault.azure.net/"
tribunals_frontend_external_cert_name = "core-compute-aat"


#================================================================================================
# Azure Monitor
#================================================================================================
monitor_action_group = {
  "sscs-aat-dead-letter" = {
    short_name = "sscsDeadLet"
    email_receiver = [
      {
        email_receiver_name = "SSCS Alerts"
      }
    ]
  }
}


monitor_metric_alerts = {
  "sscs-aat-dead-letter-alerts" = {
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
            values   = ["tribunals-to-hearing-api-aat"]
          }
        ]
      }
    ]
    action = [
      {
        action_group_name = "sscs-aat-dead-letter"
      }
    ]
  }
}

sftp_allowed_key_secrets = ["sftp-user-pub-key"]
sftp_access_AAD_objectId = "aa694620-518d-44a4-b494-0f8fe298f2b0" // dcd_sscs
sftp_allowed_sa_subnets = [
  "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/cft-ptl-network-rg/providers/Microsoft.Network/virtualNetworks/cft-ptl-vnet/subnets/iaas", // Jenkins subnet
  "/subscriptions/96c274ce-846d-4e48-89a7-d528432298a7/resourceGroups/cft-aat-network-rg/providers/Microsoft.Network/virtualNetworks/cft-aat-vnet/subnets/aks-00",
  "/subscriptions/96c274ce-846d-4e48-89a7-d528432298a7/resourceGroups/cft-aat-network-rg/providers/Microsoft.Network/virtualNetworks/cft-aat-vnet/subnets/aks-01"
]
