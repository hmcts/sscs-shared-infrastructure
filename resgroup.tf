resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"
  tags     = "${local.tags}"
}

locals {
  tags = "${merge(var.common_tags,
    map("lastUpdated", "${timestamp()}"),
    map("Team Name", "${var.team_name}"),
    map("Team Contact", "${var.team_contact}")
    )}"
}
