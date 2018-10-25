locals {
  sftp_resgroup_name   = "core-infra-${var.env}-sftp"
  sftp_subnet_name     = "${var.product}-${var.env}-sftp"
  sftp_packer_image_id = "/subscriptions/${var.subscription_id}/resourceGroups/sscs-sftp-${var.env}/providers/Microsoft.Compute/images/${var.sftp_packer_image_name}"
}

// Get secrets from Azure Vault
data "azurerm_key_vault" "infra_vault" {
  name = "infra-vault-${var.subscription_name}"
  resource_group_name = "${var.infra_vault_resgroup}"
}

data "azurerm_key_vault_secret" "sscs-sftp-admin-public-key" {
  name = "sscs-sftp-admin-public-key-${var.env}"
  vault_uri = "${data.azurerm_key_vault.infra_vault.vault_uri}"
}

// Create dedicated resource group for sftp stuff as it is quite a separate project
resource "azurerm_resource_group" "sftp" {
  name     = "${local.sftp_resgroup_name}"
  location = "${var.location}"
}

// Apparently the subnet must be created in the same resource group as the vnet

resource "azurerm_subnet" "sftp" {
  name                 = "${local.sftp_subnet_name}"
  resource_group_name  = "${var.sftp_existing_resgroup_name}"
  virtual_network_name = "${var.sftp_existing_vnet_name}"
  address_prefix       = "${var.sftp_subnet_range}"
}

// use the "sftp" module as many times as there are sftp servers

module "sftp01" {
  source                = "git::git@github.com:hmcts/cnp-module-sftp?ref=master"
  env                   = "${var.env}"
  product               = "${var.product}"
  location              = "${var.location}"
  vm_name               = "${var.product}-${var.env}-sftp01"
  vm_size               = "${var.sftp_vm_size}"
  disk_size_gb          = "${var.sftp_disk_size_gb}"
  resource_group_name   = "${local.sftp_resgroup_name}"
  subnet_id             = "${azurerm_subnet.sftp.id}"
  admin_username        = "${var.sftp_admin_username}"
  admin_ssh_key         = "${data.azurerm_key_vault_secret.sscs-sftp-admin-public-key.value}"
  sftp_packer_image_id  = "${local.sftp_packer_image_id}"
}
