
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

resource "azurerm_key_vault_secret" "github-apikey" {
  name = "github-apikey"
  value = "TBC"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "bootstrap-creds" {
  name = "bootstrap-creds"
  value = "${file("bootstrap-creds.json")}"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "cfg-vmimg-store" {
  name = "cfg-vmimg-store"
  value = "${file("cfg-vmimg-store.json")}"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "sftp-ssh-private-key" {
  name = "sftp-ssh-private-key"
  value = "${file("sscs-shared-infrastructure")}"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}

resource "azurerm_key_vault_secret" "hashicorp-vault-token" {
  name = "hashicorp-vault-token"
  value = "TBC"
  vault_uri = "${module.sscs-vault.key_vault_uri}"
}