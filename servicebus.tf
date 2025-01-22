locals {
  evidenceshare_topic_name         = "${var.product}-evidenceshare-topic-${var.env}"
  correspondence_topic_name        = "${var.product}-correspondence-topic-${var.env}"
  correspondence_subscription_name = "${var.product}-correspondence-subscription-${var.env}"
  evidenceshare_subscription_name  = "${var.product}-evidenceshare-subscription-${var.env}"
  servicebus_namespace_name        = "${var.product}-servicebus-${var.env}"
  resource_group_name              = azurerm_resource_group.rg.name
}

module "servicebus-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=4.x"
  name                = local.servicebus_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = var.service_bus_sku
  capacity            = var.capacity
}

module "evidenceshare-topic" {
  source                                  = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=4.x"
  name                                    = local.evidenceshare_topic_name
  namespace_name                          = local.servicebus_namespace_name
  resource_group_name                     = local.resource_group_name
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "PT1H"
  max_size_in_megabytes                   = 3072
  max_message_size_in_kilobytes           = var.max_message_size_in_kilobytes
  depends_on                              = [module.servicebus-namespace]
}

module "evidenceshare-subscription" {
  source       = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=4.x"
  name         = local.evidenceshare_subscription_name
  namespace_id = module.servicebus-namespace.id
  topic_name   = local.evidenceshare_topic_name

  depends_on = [module.evidenceshare-topic]
}


output "sb_primary_send_and_listen_shared_access_key" {
  value     = module.servicebus-namespace.primary_send_and_listen_shared_access_key
  sensitive = true
}

resource "azurerm_key_vault_secret" "servicebus_primary_shared_access_key" {
  name         = "sscs-servicebus-shared-access-key"
  value        = module.servicebus-namespace.primary_send_and_listen_shared_access_key
  key_vault_id = module.sscs-vault.key_vault_id

  content_type = "terraform-managed,service-bus"
  tags = merge(local.tags, {
    "source" : "Service Bus ${module.servicebus-namespace.name}"
  })
}

output "sb_primary_send_and_listen_connection_string" {
  value     = module.servicebus-namespace.primary_send_and_listen_connection_string
  sensitive = true
}

resource "azurerm_key_vault_secret" "servicebus_primary_connection_string" {
  name         = "sscs-servicebus-connection-string-tf"
  value        = module.servicebus-namespace.primary_send_and_listen_connection_string
  key_vault_id = module.sscs-vault.key_vault_id

  content_type = "terraform-managed,service-bus"
  tags = merge(local.tags, {
    "source" : "Service Bus ${module.servicebus-namespace.name}"
  })
}

output "evidence_share_topic_primary_shared_access_key" {
  value     = module.evidenceshare-topic.primary_send_and_listen_shared_access_key
  sensitive = true
}

resource "azurerm_key_vault_secret" "evidence_share_topic_primary_shared_access_key" {
  name         = "evidence-share-topic-shared-access-key"
  value        = module.evidenceshare-topic.primary_send_and_listen_shared_access_key
  key_vault_id = module.sscs-vault.key_vault_id

  content_type = "terraform-managed,service-bus"
  tags = merge(local.tags, {
    "source" : "Service Bus ${module.evidenceshare-topic.name}"
  })
}

module "correspondence-topic" {
  source                                  = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=4.x"
  name                                    = local.correspondence_topic_name
  namespace_name                          = local.servicebus_namespace_name
  resource_group_name                     = local.resource_group_name
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "PT1H"
  max_size_in_megabytes                   = 2048
  max_message_size_in_kilobytes           = var.max_message_size_in_kilobytes
  depends_on                              = [module.servicebus-namespace]
}

module "correspondence-subscription" {
  source       = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=4.x"
  name         = local.correspondence_subscription_name
  namespace_id = module.servicebus-namespace.id
  topic_name   = local.correspondence_topic_name

  depends_on = [module.correspondence-topic]
}

resource "azurerm_key_vault_secret" "correspondence_topic_primary_shared_access_key" {
  name         = "correspondence-topic-shared-access-key"
  value        = module.correspondence-topic.primary_send_and_listen_shared_access_key
  key_vault_id = module.sscs-vault.key_vault_id

  content_type = "terraform-managed,service-bus"
  tags = merge(local.tags, {
    "source" : "Service Bus ${module.correspondence-topic.name}"
  })
}

data "azurerm_servicebus_namespace" "hmc_servicebus_namespace" {
  name                = join("-", ["hmc-servicebus", var.env])
  resource_group_name = join("-", ["hmc-shared", var.env])
}

module "servicebus-subscription" {
  source       = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=4.x"
  name         = "hmc-to-sscs-subscription-${var.env}"
  namespace_id = data.azurerm_servicebus_namespace.hmc_servicebus_namespace.id
  topic_name   = "hmc-to-cft-${var.env}"
}

resource "azurerm_servicebus_subscription_rule" "topic_filter_rule_sscs" {
  name            = "hmc-servicebus-${var.env}-subscription-rule-bba3"
  subscription_id = module.servicebus-subscription.id
  filter_type     = "CorrelationFilter"

  correlation_filter {
    properties = {
      hmctsServiceId = "BBA3"
    }
  }
}

resource "azurerm_servicebus_subscription_rule" "topic_deployment_filter_rule_sscs" {
  name            = "hmc-servicebus-${var.env}-subscription-rule-deployment"
  subscription_id = module.servicebus-subscription.id
  filter_type     = "CorrelationFilter"
  count           = var.hearings_deployment_id != "" ? 1 : 0

  sql_filter = "hmctsDeploymentId IS NULL"
}


data "azurerm_key_vault" "hmc-key-vault" {
  name                = "hmc-${var.env}"
  resource_group_name = "hmc-shared-${var.env}"
}

data "azurerm_key_vault_secret" "hmc-servicebus-connection-string" {
  key_vault_id = data.azurerm_key_vault.hmc-key-vault.id
  name         = "hmc-servicebus-connection-string"
}

resource "azurerm_key_vault_secret" "hmc-servicebus-connection-string" {
  name         = "hmc-servicebus-connection-string"
  value        = data.azurerm_key_vault_secret.hmc-servicebus-connection-string.value
  key_vault_id = module.sscs-vault.key_vault_id

  content_type = "secret"
  tags = merge(var.common_tags, {
    "source" : "Vault ${module.sscs-vault.key_vault_id}"
  })
}

data "azurerm_key_vault_secret" "hmc-servicebus-shared-access-key" {
  key_vault_id = data.azurerm_key_vault.hmc-key-vault.id
  name         = "hmc-servicebus-shared-access-key"
}

resource "azurerm_key_vault_secret" "sscs-hmc-servicebus-shared-access-key-tf" {
  name         = "hmc-servicebus-shared-access-key-tf"
  value        = data.azurerm_key_vault_secret.hmc-servicebus-shared-access-key.value
  key_vault_id = module.sscs-vault.key_vault_id

  content_type = "secret"
  tags = merge(var.common_tags, {
    "source" : "Vault ${module.sscs-vault.key_vault_id}"
  })
}
