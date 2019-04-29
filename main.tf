provider "azurerm" {
  version = "1.22.1"
}

locals {
  tags = "${merge(var.common_tags,
    map("Team Contact", "#sscs")
    )}"
}
