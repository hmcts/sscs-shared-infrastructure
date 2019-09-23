provider "azurerm" {
  version = "1.33.1"
}

locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#sscs")
    )}"
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "hmcts-${var.subscription}"
  resource_group_name = "oms-automation"
}