data "azurerm_key_vault_secret" "sscs_failure_email_secret" {
  name         = "sscs-failure-email-to"
  key_vault_id = module.sscs-vault.key_vault_id
}

module "sscs-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = var.env

  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "SSCS Fail Alert - ${var.env}"
  short_name             = "SSCSF_alert"
  email_receiver_name    = "SSCS Alerts"
  email_receiver_address = data.azurerm_key_vault_secret.sscs_failure_email_secret.value
}

module "sscs-fail-action-group-slack" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = var.env

  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "SSCS Fail Slack Alert - ${var.env}"
  short_name             = "SSCSF_slack"
  email_receiver_name    = "SSCS Alerts"
  email_receiver_address = "sscs-prod-monitoring-aaaac7vjnaaknbv4uixozinjim@hmcts-reform.slack.com"
}

data "azurerm_key_vault_secret" "sscs_alert_email_secret" {
  for_each = var.monitor_action_group

  name         = each.value.email_secret_name  # Use the dynamic secret name
  key_vault_id = module.sscs-vault.key_vault_id
}


resource "azurerm_monitor_action_group" "scs-dead-letter-action-group" {
  for_each = var.monitor_action_group

  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = each.value.short_name
  enabled             = try(each.value.enabled, null)

  dynamic "email_receiver" {
    for_each = try(each.value.email_receiver, {})
    content {
      name                    = email_receiver.value.email_receiver_name
      email_address           = data.azurerm_key_vault_secret.sscs_alert_email_secret[each.key].value
      use_common_alert_schema = try(email_receiver.value.use_common_alert_schema, null)
    }
  }

  tags = local.tags
}