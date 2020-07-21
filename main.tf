provider "azurerm" {
  version = "1.33.1"
}

locals {
  tags = "${
    merge(
      var.common_tags,
      map(
        "Team Contact", "#sscs",
        "Team Name", "SSCS Team"
      )
    )}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}
