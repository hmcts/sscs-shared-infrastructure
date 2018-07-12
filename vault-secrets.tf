
resource "azurerm_key_vault_secret" "jumpbox-username" {
  name = "sscs-sftp-${environment}-jumpbox-username"
  value = "root"
  vault_uri = "${sftp_vault_url}"
}

resource "azurerm_key_vault_secret" "admin-username" {
  name = "sscs-sftp-${environment}-admin-username"
  value = "root"
  vault_uri = "${sftp_vault_url}"
}

resource "azurerm_key_vault_secret" "admin_password" {
  name = "sscs-sftp-${environment}-admin_password"
  value = "${random_string.admin_password.result}" 
  vault_uri = "${sftp_vault_url}"
}

resource "azurerm_key_vault_secret" "github-apikey" {
  name = "sscs-sftp-${environment}-github-apikey"
  value = "${file("github-apikey")}"
  vault_uri = "${sftp_vault_url}"
}

resource "azurerm_key_vault_secret" "bootstrap-creds" {
  name = "sscs-sftp-${environment}-bootstrap-creds"
  value = "${file("bootstrap-creds.json")}"
  vault_uri = "${sftp_vault_url}"
}

resource "azurerm_key_vault_secret" "cfg-vmimg-store" {
  name = "sscs-sftp-${environment}-cfg-vmimg-store"
  value = "${file("cfg-vmimg-store.json")}"
  vault_uri = "${sftp_vault_url}"
}

resource "azurerm_key_vault_secret" "sftp-ssh-private-key" {
  name = "sscs-sftp-${environment}-sftp-ssh-private-key"
  value = "${file("sscs-shared-infrastructure")}"
  vault_uri = "${sftp_vault_url}"
}

resource "azurerm_key_vault_secret" "hashicorp-vault-token" {
  name = "sscs-sftp-${environment}-hashicorp-vault-token"
  value = "${file("hashicorp-vault-token")}"
  vault_uri = "${sftp_vault_url}"
}