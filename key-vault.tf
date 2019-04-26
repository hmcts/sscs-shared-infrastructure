variable "tenant_id" {
  type        = "string"
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  type        = "string"
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}

module "sscs-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "sscs-${var.env}"
  product                 = "${var.product}"
  env                     = "${var.env}"
  tenant_id               = "${var.tenant_id}"
  object_id               = "${var.jenkins_AAD_objectId}"
  resource_group_name     = "${azurerm_resource_group.rg.name}"
  product_group_object_id = "87099fce-881e-4654-88d2-7c36b634e622"
  common_tags             = "${local.tags}"
}

output "vaultName" {
  value = "${module.sscs-vault.key_vault_name}"
}

data "azurerm_key_vault" "sscs_key_vault" {
  name                = "sscs-${var.env}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

