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
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.servicebus_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = var.service_bus_sku
  zone_redundant      = var.zone_redundant
  capacity            = var.capacity
}

module "evidenceshare-topic" {
  source                                  = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                                    = local.evidenceshare_topic_name
  namespace_name                          = local.servicebus_namespace_name
  resource_group_name                     = local.resource_group_name
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "PT1H"
  max_size_in_megabytes                   = 2048
  max_message_size_in_kilobytes           = var.max_message_size_in_kilobytes
  depends_on                              = [module.servicebus-namespace]
}

module "evidenceshare-subscription" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                = local.evidenceshare_subscription_name
  namespace_name      = local.servicebus_namespace_name
  resource_group_name = local.resource_group_name
  topic_name          = local.evidenceshare_topic_name

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
  source                                  = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
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
  source              = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                = local.correspondence_subscription_name
  namespace_name      = local.servicebus_namespace_name
  resource_group_name = local.resource_group_name
  topic_name          = local.correspondence_topic_name

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
