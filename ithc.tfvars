tribunals_frontend_external_hostname = "sscs-tribunals-frontend.ithc.platform.hmcts.net"

external_cert_vault_uri               = "https://infra-vault-qa.vault.azure.net/"
tribunals_frontend_external_cert_name = "wildcard-ithc-platform-hmcts-net"

#================================================================================================
# Azure Monitor
#================================================================================================
monitor_action_group = {
  "sscs-ci-slack-alert" = {
    short_name = "sscsci"
    email_secret_name = "sscs-ci-slack-alert"
    email_receiver = [
      {
        email_receiver_name = "SSCS CI Alerts"
      }
    ]
  }
}


monitor_metric_alerts = {
  "sscs-ithc-dead-letter-alerts" = {
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
            values   = ["tribunals-to-hearing-api-ithc"]
          }
        ]
      }
    ]
    action = [
      {
        action_group_name = "sscs-ci-slack-alert"
      }
    ]
  }
}

sftp_access_AAD_objectId = "aa694620-518d-44a4-b494-0f8fe298f2b0" // dcd_sscs
