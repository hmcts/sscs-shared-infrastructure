
resource "azurerm_storage_account" "sftp_storage" {
  name                     = "sscssftp${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  sftp_enabled             = true

  tags = {
    environment  = "sandbox"
    application  = "heritage"
    businessArea = "cross-cutting"
    builtFrom    = "terraform"
  }
}

resource "azurerm_storage_container" "sftp_container" {
  name                  = "upload"
  storage_account_name  = azurerm_storage_account.sftp_storage.name
  container_access_type = "private"
}

data "azurerm_key_vault_secret" "sftp_user_key" {
  name         = "sftp-user-pub-key"
  key_vault_id = module.sscs-vault.key_vault_id
}

data "azurerm_key_vault_secret" "sftp_user_name" {
  name         = "sftp-user"
  key_vault_id = module.sscs-vault.key_vault_id
}

# Workaround until azurerm_storage_account supports the ability to create local users
resource "azapi_resource" "add_local_user" {
  type = "Microsoft.Storage/storageAccounts/localUsers@2021-09-01"
  name = "${data.azurerm_key_vault_secret.sftp_user_name.value}"
  parent_id = azurerm_storage_account.sftp_storage.id

  body = jsonencode({
    properties = {
      "permissionScopes" : [
        {
          "permissions" : "rwd",
          "service" : "blob",
          "resourceName" : "upload"
        }
      ],
      "hasSshPassword" : false,
      "hasSshKey" : true
      "sshAuthorizedKeys" : [
        {
          "description" : "key name",
          "key" : "${data.azurerm_key_vault_secret.sftp_user_key.value}"
        }
      ],
      "homeDirectory" : "upload"
    }
  })
}
