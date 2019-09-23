module "sscs-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name                 = "sscs-fail-alert"
  alert_desc                 = "Triggers when an SSCS exception is received in a 5 minute poll."
  app_insights_query         = "exceptions"
  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = "${module.sscs-fail-action-group.action_group_name}"
  custom_email_subject       = "SSCS Service Exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_template_deployment" "caseloader_finished_processing" {
  count               = "${var.subscription != "sandbox" ? 1 : 0}"
  name                = "caseloader_finished_processing_${var.env}"
  resource_group_name = "${data.azurerm_log_analytics_workspace.log_analytics.resource_group_name}"
  deployment_mode     = "Incremental"

  parameters = {
    workspaceName = "${data.azurerm_log_analytics_workspace.log_analytics.name}"
    ActionGroupName = "${module.elastic_ccd_action_group.action_group_name}"
    DisplayNameOfSearch = "Caseloader has finished processing on ${var.env}"
    UniqueNameOfSearch = "Caseloader-finished-processing-${var.env}"
    Description = "Triggers after “XML summary” is seen in the logs, which indicates caseloader has finished processing on ${var.env}"
    SearchQuery = "traces | where (message has \"XML summary\") | where cloud_RoleName == \"CaseLoader Insights WebApp\" | sort by timestamp desc"
    Severity = "informational"
    TimeWindow = "10"
    AlertFrequency = "1"
    AggregateValueOperator = "gt"
    AggregateValue = "0"
    TriggerAlertCondition = "Total"
    TriggerAlertOperator = "gt"
    TriggerAlertValue = "0"
  }
}