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