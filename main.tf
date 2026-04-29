provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  alias                           = "private_endpoint"
  subscription_id                 = var.aks_subscription_id
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

data "azurerm_user_assigned_identity" "jenkins" {
  name                = "jenkins-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}