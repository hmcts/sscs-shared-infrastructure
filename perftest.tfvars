tribunals_frontend_external_hostname = "benefit-appeal.perftest.platform.hmcts.net"

external_cert_vault_uri               = "https://infra-vault-qa.vault.azure.net/"
tribunals_frontend_external_cert_name = "wildcard-perftest-platform-hmcts-net"

#================================================================================================
# Azure Monitor
#================================================================================================
monitor_action_group = {
  "sscs-perftest-dead-letter" = {
    short_name = "sscsDeadLet"
    email_receiver = [
      {
        email_receiver_name = "SSCS Alerts"
      }
    ]
  }
}


monitor_metric_alerts = {
  "sscs-perftest-dead-letter-alerts" = {
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
            values   = ["tribunals-to-hearing-api-perftest"]
          }
        ]
      }
    ]
    action = [
      {
        action_group_name = "sscs-perftest-dead-letter"
      }
    ]
  }
}