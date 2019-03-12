module "queue-namespace" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace.git"
  name                = "${var.product}-servicebus-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  common_tags         = "${var.common_tags}"
}

module "evidenceshare-queue" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-queue.git"
  name                = "evidenceshare"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  requires_duplicate_detection            = "true"
  duplicate_detection_history_time_window = "PT1H"
  lock_duration                           = "PT5M"
  max_delivery_count                      = "288" // To retry processing the message for 24hours
}

resource "azurerm_servicebus_topic" "example" {
  name                = "evidenceshare_topic"
  namespace_name      = "${module.queue-namespace.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  enable_partitioning = true
}

output "evidenceshare_queue_primary_listen_connection_string" {
  value = "${module.evidenceshare-queue.primary_listen_connection_string}"
}

output "evidenceshare_queue_primary_send_connection_string" {
  value = "${module.evidenceshare-queue.primary_send_connection_string}"
}
