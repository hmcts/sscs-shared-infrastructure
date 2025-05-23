module "sscs-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = "${var.product}-${var.env}"

  alert_name                 = "sscs-fail-alert"
  alert_desc                 = "Triggers when an SSCS exception is received in a 5 minute poll."
  app_insights_query         = "exceptions | where appName == \"sscs-prod\" | sort by timestamp desc"
  frequency_in_minutes       = "5"
  time_window_in_minutes     = "5"
  severity_level             = "3"
  action_group_name          = module.sscs-fail-action-group.action_group_name
  custom_email_subject       = "SSCS Service Exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  common_tags                = var.common_tags
  depends_on                 = [module.application_insights]
}

module "sscs-sya-submit-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = "${var.product}-${var.env}"

  alert_name                 = "sscs-sya-submit-fail"
  alert_desc                 = "Triggers when SYA has multiple Appeal submission fails."
  app_insights_query         = "customEvents | where name contains \"SYA-SendToApi-Failed\" | where appName == \"sscs-prod\" | sort by timestamp desc"
  frequency_in_minutes       = "15"
  time_window_in_minutes     = "15"
  severity_level             = "2"
  action_group_name          = module.sscs-fail-action-group-slack.action_group_name
  custom_email_subject       = "Multiple SSCS SYA Submission Failing"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "1"
  resourcegroup_name         = azurerm_resource_group.rg.name
  common_tags                = var.common_tags
  depends_on                 = [module.application_insights]
}

resource "azurerm_monitor_metric_alert" "alerts" {
  for_each            = var.monitor_metric_alerts
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.servicebus-namespace.id]
  window_size         = try(each.value.window_size, null)
  frequency           = try(each.value.frequency, null)

  dynamic "criteria" {
    for_each = try(each.value.criteria, {})
    content {
      metric_namespace       = criteria.value.metric_namespace
      metric_name            = criteria.value.metric_name
      aggregation            = criteria.value.aggregation
      operator               = criteria.value.operator
      threshold              = criteria.value.threshold
      skip_metric_validation = try(criteria.value.skip_metric_validation, null)

      dynamic "dimension" {
        for_each = try(criteria.value.dimension, {})
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  # Dynamic block for action
  dynamic "action" {
    for_each = try(each.value.action, [])
    content {
      action_group_id = azurerm_monitor_action_group.sscs-action-group[action.value.action_group_name].id # Reference the action group
    }
  }

  tags = local.tags
}
