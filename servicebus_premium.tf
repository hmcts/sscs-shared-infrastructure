locals {
  servicebus_namespace_name_premium       = "${var.product}-servicebus-${var.env}-premium"
}

module "servicebus-namespace-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.servicebus_namespace_name_premium
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
  sku                 = "Premium"
  zoneRedundant       = true
  capacity            = 1
}

module "evidenceshare-topic-premium" {
  source                                  = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                                    = local.evidenceshare_topic_name
  namespace_name                          = local.servicebus_namespace_name
  resource_group_name                     = local.resource_group_name
  requires_duplicate_detection            =  true
  duplicate_detection_history_time_window = "PT60M"
}

module "evidenceshare-subscription-premium" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                  = local.evidenceshare_subscription_name
  namespace_name        = local.servicebus_namespace_name_premium
  resource_group_name   = local.resource_group_name
  topic_name            = local.evidenceshare_topic_name
}

module "notifications-subscription-premium" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                  = local.notifications_subscription_name
  namespace_name        = local.servicebus_namespace_name_premium
  resource_group_name   = local.resource_group_name
  topic_name            = local.evidenceshare_topic_name
}
