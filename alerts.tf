module "sscs-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name                 = "sscs-tribunals-case-api-fail-alert"
  alert_desc                 = "Triggers when an SSCS exception is received in a 5 minute poll."
  app_insights_query         = "exceptions | where notempty(client_Browser)"
  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = "${module.sscs-fail-action-group.action_group_name}"
  custom_email_subject       = "SSCS Service Exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}