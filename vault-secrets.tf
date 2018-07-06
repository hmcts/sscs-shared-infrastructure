
resource "azurerm_key_vault_secret" "bastion_host" {
  name = "bastion_host"
  value = "test.host.name"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}