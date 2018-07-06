
resource "azurerm_key_vault_secret" "jumpbox-username" {
  name = "jumpbox-username"
  value = "test.bastion.user.name"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}