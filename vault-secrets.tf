
resource "azurerm_key_vault_secret" "jumpbox-username" {
  name = "jumpbox-username"
  value = "test.bastion.user.name"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "admin-username" {
  name = "admin-username"
  value = "test.admin.user.name"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "admin-password" {
  name = "admin-password"
  value = "test.admin.user.name"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}