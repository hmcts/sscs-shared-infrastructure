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
        module_name = "sscs-ci-slack-action-group"
      }
    ]
  }
}

sftp_access_AAD_objectId = "aa694620-518d-44a4-b494-0f8fe298f2b0" // dcd_sscs
