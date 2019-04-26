provider "azurerm" {
  version = "1.21.0"
}

locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#sscs")
    )}"
}