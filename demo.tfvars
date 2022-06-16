tribunals_frontend_external_hostname = "sscs-tribunals-frontend-demo.service.core-compute-demo.internal"

external_cert_vault_uri               = "https://infra-vault-nonprod.vault.azure.net/"
tribunals_frontend_external_cert_name = "core-compute-demo"


#================================================================================================
# Azure Monitor
#================================================================================================
monitor_action_group = {
  "sscs-demo-dead-letter" = {
    short_name = "sscsDeadLet"
    email_receiver = [
      {
        email_receiver_name = "SSCS Alerts"
      }
    ]
  }
}


monitor_metric_alerts = {
  "sscs-demo-dead-letter-alerts" = {
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
            values   = ["tribunals-to-hearing-api-demo"]
          }
        ]
      }
    ]
    action = [
      {
        action_group_name = "sscs-demo-dead-letter"
      }
    ]
  }
}