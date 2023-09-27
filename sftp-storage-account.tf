locals {
  private_endpoint_rg_name   = var.businessArea == "sds" ? "ss-${var.env}-network-rg" : "${var.businessArea}-${var.env}-network-rg"
  private_endpoint_vnet_name = var.businessArea == "sds" ? "ss-${var.env}-vnet" : "${var.businessArea}-${var.env}-vnet"
}

# CFT only, on SDS remove this provider
provider "azurerm" {
  alias           = "private_endpoints"
  subscription_id = var.aks_subscription_id
  features {}
  skip_provider_registration = true
}

data "azurerm_subnet" "private_endpoints" {
  # CFT only you will need to provide an extra provider, uncomment the below line, on SDS remove this line and the next
  provider = azurerm.private_endpoints

  resource_group_name  = local.private_endpoint_rg_name
  virtual_network_name = local.private_endpoint_vnet_name
  name                 = "private-endpoints"
}

module "sftp_storage" {
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=fix/private-endpoint-provider"
  env                      = var.env
  storage_account_name     = "sscssftp${var.env}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_hns               = "true"
  enable_sftp              = "true"

  managed_identity_object_id = var.sftp_access_AAD_objectId
  role_assignments = [
    "Storage Blob Data Contributor"
  ]

  private_endpoint_subscription_id = var.aks_subscription_id
  private_endpoint_subnet_id       = data.azurerm_subnet.private_endpoints.id
  private_endpoint_rg_name         = local.private_endpoint_rg_name

  team_name    = "SSCS Team"
  team_contact = "#sscs"
  common_tags  = var.common_tags
  tags         = var.autoShutdown
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

#TODO: Replace this API call with azurerm_storage_account_local_user resource
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