locals {
  evidenceshare_topic_name        = "${var.product}-evidenceshare-topic-${var.env}"
  evidenceshare_subscription_name = "${var.product}-evidenceshare-subscription-${var.env}"
  notifications_subscription_name = "${var.product}-notifications-subscription-${var.env}"
  servicebus_namespace_name       = "${var.product}-servicebus-${var.env}"
  resource_group_name             = azurerm_resource_group.rg.name
}
