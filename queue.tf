
module "servicebus-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace.git"
  name                = "${var.product}-servicebus-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  common_tags         = "${var.common_tags}"
}

module "evidenceshare-topic" {
  source                = "git@github.com:hmcts/terraform-module-servicebus-topic.git"
  name                  = "evidenceshare_topic"
  namespace_name        = "${module.servicebus-namespace.name}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
}

output "evidenceshare_topic_primary_send_and_listen_connection_string" {
  value = "${module.evidenceshare-queue.primary_send_and_listen_connection_string}"
}

output "evidenceshare_topic_secondary_send_and_listen_connection_string" {
  value = "${module.evidenceshare-queue.secondary_send_and_listen_connection_string}"
}

output "evidenceshare_topic_primary_send_and_listen_shared_access_key" {
  value = "${module.evidenceshare-queue.primary_send_and_listen_shared_access_key}"
}

output "evidenceshare_topic_secondary_send_and_listen_shared_access_key" {
  value = "${module.evidenceshare-queue.secondary_send_and_listen_shared_access_key}"
}
