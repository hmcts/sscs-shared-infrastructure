module "sscs-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "sscs-${var.env}"
  product                 = var.product
  env                     = var.env
  tenant_id               = var.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_object_id = "87099fce-881e-4654-88d2-7c36b634e622"
  common_tags             = local.tags
  location                = var.location

  create_managed_identity    = true
}

data "azurerm_key_vault" "sscs_key_vault" {
  name                = "sscs-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
}

output "vaultName" {
  value = module.sscs-vault.key_vault_name
}

output "vaultUri" {
  value = module.sscs-vault.key_vault_uri
}
