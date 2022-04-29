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
