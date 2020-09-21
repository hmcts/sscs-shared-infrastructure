provider "azurerm" {
  features {}
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
