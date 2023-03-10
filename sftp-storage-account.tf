/*
resource "azurerm_storage_account" "sftp_storage" {
  name                     = "sscssftp${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  sftp_enabled             = true
  tags                     = local.tags
}*/

module "sftp_storage" {
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=feature/sftp-support"
  env                      = var.env
  storage_account_name     = "sscssftp${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_hns               = "true"
  enable_sftp              = "true"
  default_action           = var.sftp_default_action
  
  managed_identity_object_id = var.sftp_access_AAD_objectId
  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  sa_subnets = var.sftp_allowed_sa_subnets

  team_name    = "SSCS Team"
  team_contact = "#sscs"
  common_tags  = var.common_tags
}

resource "azurerm_storage_container" "sftp_container" {
  name                  = "upload"
  storage_account_name  = module.sftp_storage.storageaccount_name
  container_access_type = "private"
}

data "azurerm_key_vault_secret" "sftp_user_keys" {
  for_each     = toset(var.sftp_allowed_key_secrets)
  name         = each.value #"sftp-user-pub-key"
  key_vault_id = module.sscs-vault.key_vault_id
}

data "azurerm_key_vault_secret" "sftp_user_name" {
  name         = "sftp-user-name"
  key_vault_id = module.sscs-vault.key_vault_id
}

# Workaround until azurerm_storage_account supports the ability to create local users
resource "azapi_resource" "add_local_user" {
  type = "Microsoft.Storage/storageAccounts/localUsers@2021-09-01"
  name = "${data.azurerm_key_vault_secret.sftp_user_name.value}"
  parent_id = module.sftp_storage.storageaccount_id

  body = jsonencode({
    properties = {
      "permissionScopes" : [
        {
          "permissions" : "rwdcl",
          "service" : "blob",
          "resourceName" : "upload"
        }
      ],
      "hasSshPassword" : true,
      "sshAuthorizedKeys" : [
        for k in data.azurerm_key_vault_secret.sftp_user_keys : {
          "description": k.name,
          "key": k.value
        }
      ],
      "homeDirectory" : "upload"
    }
  })
}
