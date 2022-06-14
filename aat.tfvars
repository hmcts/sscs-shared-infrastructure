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

# monitor_metric_alerts = {
#   "uks-pk8s-esit-ggss-nodeready-alerts" = {
#     metric_alert_name="sscs-dead-letter-alert"
#     description = "Action will be triggered when the average count of dead-lettered messages in a queue/topic is greater than 0."
#     metric_namespace = "Microsoft.ServiceBus/namespaces"
#     metric_name      = "DeadletteredMessages"
#     aggregation      = "Average"
#     operator         = "GreaterThan"
#     threshold        = 0
#     dimension_name     = "ApiName"
#     dimension_operator = "Include"
#     dimension_va    = ["*"]
#     criteria = [
#       {
#         metric_namespace = "Microsoft.ContainerService/managedClusters"
#         metric_name      = "kube_node_status_condition"
#         aggregation      = "Total"
#         operator         = "GreaterThan"
#         threshold        = 0
#         dimension = [
#           {
#             name     = "condition"
#             operator = "Include"
#             values   = ["Ready"]
#           },
#           {
#             name     = "status2"
#             operator = "Exclude"
#             values   = ["Ready"]
#           },
#           {
#             name     = "node"
#             operator = "StartsWith"
#             values   = ["aks-ggs"]
#           },
#         ]
#       }
#     ]
#     action = [
#       {
#         action_group_name = "uks-pk8s-esit-ggss-alerts"
#       }
#     ]
#   }
# }