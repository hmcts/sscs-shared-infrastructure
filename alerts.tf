module "sscs-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  alert_name                 = "sscs-fail-alert"
  alert_desc                 = "Triggers when an SSCS exception is received in a 5 minute poll."
  app_insights_query         = "exceptions | where appName == \"sscs-prod\" | sort by timestamp desc"
  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = module.sscs-fail-action-group.action_group_name
  custom_email_subject       = "SSCS Service Exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = azurerm_resource_group.rg.name
  common_tags                = var.common_tags
}

module "sscs-sya-submit-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  alert_name                 = "sscs-sya-submit-fail"
  alert_desc                 = "Triggers when SYA has multiple Appeal submission fails."
  app_insights_query         = "customEvents | where name contains \"SYA-SendToApi-Failed\" | where appName == \"sscs-prod\" | sort by timestamp desc"
  frequency_in_minutes       = 15
  time_window_in_minutes     = 15
  severity_level             = "2"
  action_group_name          = module.sscs-fail-action-group-slack.action_group_name
  custom_email_subject       = "Multiple SSCS SYA Submission Failing"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 1
  resourcegroup_name         = azurerm_resource_group.rg.name
  common_tags                = var.common_tags
}

# module "sscs-dead-letter-alert" {
#   source            = "git@github.com:hmcts/cnp-module-metric-alert"
#   location          = azurerm_application_insights.appinsights.location
#   app_insights_name = azurerm_application_insights.appinsights.name

#   alert_name                 = "sscs-dead-letter-alert"
#   alert_desc                 = "Triggers when an SSCS dead letter queue is done a 5 minute poll."
#   app_insights_query         = "exceptions | where appName == \"sscs-prod\" | sort by timestamp desc"
#   frequency_in_minutes       = 5
#   time_window_in_minutes     = 5
#   severity_level             = "3"
#   action_group_name          = module.sscs-fail-action-group.action_group_name
#   custom_email_subject       = "SSCS Service Exception"
#   trigger_threshold_operator = "GreaterThan"
#   trigger_threshold          = 0
#   resourcegroup_name         = azurerm_resource_group.rg.name
#   common_tags                = var.common_tags
# }

# resource "azurerm_monitor_metric_alert" "sscs-dead-letter-alert" {
#   name                = "sscs-dead-letter-alert"
#   resource_group_name = azurerm_resource_group.rg.name
#   scopes              = [module.servicebus-namespace.id]
#   description         = "Action will be triggered when the average count of dead-lettered messages in a queue/topic is greater than 0."

#   criteria {
#     metric_namespace = "Microsoft.ServiceBus/namespaces"
#     metric_name      = "DeadletteredMessages"
#     aggregation      = "Average"
#     operator         = "GreaterThan"
#     threshold        = 0

#     dimension {
#       name     = "ApiName"
#       operator = "Include"
#       values   = ["*"]
#     }
#   }

#   action {
#     action_group_id = "/subscriptions/1c4f0704-a29e-403d-b719-b90c34ef14c9/resourceGroups/sscs-demo/providers/microsoft.insights/actiongroups/sscs fail slack alert - demo" # module.sscs-dead-letter-action-group.action_group_name
#   }
# }