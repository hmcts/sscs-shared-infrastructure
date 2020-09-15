locals {
  evidenceshare_topic_name        = "${var.product}-evidenceshare-topic-${var.env}"
  evidenceshare_subscription_name = "${var.product}-evidenceshare-subscription-${var.env}"
  notifications_subscription_name = "${var.product}-notifications-subscription-${var.env}"
  servicebus_namespace_name       = "${var.product}-servicebus-${var.env}"
  resource_group_name             = azurerm_resource_group.rg.name
}

module "servicebus-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.servicebus_namespace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  env                 = var.env
  common_tags         = local.tags
}

module "evidenceshare-topic" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-topic?ref=master"
  name                  = local.evidenceshare_topic_name
  namespace_name        = local.servicebus_namespace_name
  resource_group_name   = local.resource_group_name
}

module "evidenceshare-subscription" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                  = local.evidenceshare_subscription_name
  namespace_name        = local.servicebus_namespace_name
  resource_group_name   = local.resource_group_name
  topic_name            = local.evidenceshare_topic_name
}

module "notifications-subscription" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription?ref=master"
  name                  = local.notifications_subscription_name
  namespace_name        = local.servicebus_namespace_name
  resource_group_name   = local.resource_group_name
  topic_name            = local.evidenceshare_topic_name
}