module "sscs-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  alert_name                 = "sscs-fail-alert"
  alert_desc                 = "Triggers when an SSCS exception is received in a 5 minute poll."
  app_insights_query         = "exceptions"
  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = module.sscs-fail-action-group.action_group_name
  custom_email_subject       = "SSCS Service Exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "sscs-sya-submit-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  alert_name                 = "sscs-sya-submit-fail"
  alert_desc                 = "Triggers when SYA has multiple Appeal submission fails."
  app_insights_query         = "customEvents | where name contains \"SYA-SendToApi-Failed\" | sort by timestamp desc"
  frequency_in_minutes       = 5
  time_window_in_minutes     = 15
  severity_level             = "2"
  action_group_name          = module.sscs-fail-action-group.action_group_name
  custom_email_subject       = "SSCS SYA Submission Failing"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = azurerm_resource_group.rg.name
}
