provider "azurerm" {
  version = "1.19.0"
}

locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#sscs")
    )}"
}