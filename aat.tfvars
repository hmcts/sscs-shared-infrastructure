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
    window_size = "PT15M"
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