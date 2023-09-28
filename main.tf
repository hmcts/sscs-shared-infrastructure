provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "private_endpoint"
  subscription_id            = var.aks_subscription_id
}

locals {
  tags = (merge(
    var.common_tags,
    tomap({
      "Team Contact" = "#sscs"
      "Team Name"    = "SSCS Team"
    })
  ))
}
resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location

  tags = local.tags
}
