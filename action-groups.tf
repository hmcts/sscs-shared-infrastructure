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

data "azurerm_key_vault_secret" "sscs_dead_letter_email_secret" {
  name         = "sscs-dead-letter-email-to"
  key_vault_id = module.sscs-vault.key_vault_id
}

# module "sscs-dead-letter-action-group" {
#   source = "git@github.com:hmcts/cnp-module-action-group?ref=murtest"

#   location = "global"
#   env      = var.env

#   resourcegroup_name     = azurerm_resource_group.rg.name
#   action_group_name      = "SSCS Dead Letter Queue Alert - ${var.env}"
#   short_name             = "SSCS_DLet_alert"
#   email_receiver_name    = "SSCS Alerts"
#   email_receiver_address = data.azurerm_key_vault_secret.sscs_dead_letter_email_secret.value
# }

# resource "azurerm_monitor_action_group" "scs-dead-letter-action-group" {
#   for_each = { for monitor_action_group in var.monitor_action_groups : monitor_action_group.groupName => monitor_action_group}
  
#   name                = "SSCS Dead Letter Queue Alert - ${var.env}"
#   resource_group_name = azurerm_resource_group.rg.name
#   short_name          = each.value.short_name

#   email_receiver {
#     name          = each.value.email_receiver_name
#     email_address = data.azurerm_key_vault_secret.sscs_dead_letter_email_secret.value
#   }
# }

resource "azurerm_monitor_action_group" "scs-dead-letter-action-group" {
  for_each            = var.monitor_action_group
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = each.value.short_name
  enabled             = try(each.value.enabled, null)

  dynamic "email_receiver" {
    for_each = try(each.value.email_receiver, {})
    content {
      name                    = email_receiver.value.email_receiver_name
      email_address           = data.azurerm_key_vault_secret.sscs_dead_letter_email_secret.value
      use_common_alert_schema = try(email_receiver.value.use_common_alert_schema, null)
    }
  }

  # tags = var.tags
}

# output "action_group_id" {
#   value = module.sscs-dead-letter-action-group.action_group_id
# }