tribunals_frontend_external_hostname = "sscs-tribunals-frontend.ithc.platform.hmcts.net"

external_cert_vault_uri               = "https://infra-vault-qa.vault.azure.net/"
tribunals_frontend_external_cert_name = "wildcard-ithc-platform-hmcts-net"

#================================================================================================
# Azure Monitor
#================================================================================================
monitor_action_group = {
  "sscs-ithc-dead-letter" = {
    short_name = "sscsDeadLet"
    email_receiver = [
      {
        email_receiver_name = "SSCS Alerts"
      }
    ]
  }
}


monitor_metric_alerts = {
  "sscs-ithc-dead-letter-alerts" = {
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
            values   = ["tribunals-to-hearing-api-ithc"]
          }
        ]
      }
    ]
    action = [
      {
        action_group_name = "sscs-ithc-dead-letter"
      }
    ]
  }
}