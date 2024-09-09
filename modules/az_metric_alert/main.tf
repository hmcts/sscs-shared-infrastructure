data "template_file" "actiongrouptemplate" {
  template = file("${path.module}/templates/metric-alert.json")
}

resource "azurerm_resource_group_template_deployment" "metric-alert" {
  template_content    = data.template_file.actiongrouptemplate.rendered
  resource_group_name = var.resourcegroup_name
  name                = var.arm_deployment_name
  deployment_mode     = "Incremental"

  parameters_content = jsonencode({
    actionGroupsExternalId    = { value = var.action_groups_external_id }
    alertDescription          = { value = var.alert_description }
    alertEvaluationFrequency  = { value = var.alert_evaluation_frequency }
    alertQuery                = { value = var.alert_query }
    alertSeverity             = { value = var.alert_severity }
    alertWindowSize           = { value = var.alert_window_size }
    location                  = { value = var.location }
    scheduledQueryRulesName   = { value = var.scheduled_query_rules_name }
    storageAccountsExternalId = { value = var.storage_accounts_external_id }
    commonTags                = { value = base64encode(jsonencode(var.common_tags)) }
  })

}