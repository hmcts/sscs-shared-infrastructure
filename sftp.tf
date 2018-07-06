module "sftp" {
  source                      = "git::git@github.com:hmcts/moj-module-sftp?ref=master"
  admin_username               = "${var.admin_username}"
  admin_password               = "${var.admin_password}"
  bastion_host                 = "reformMgmtDevopsBastion.reform.hmcts.net"
  subnet_id                    = "${azurerm_subnet.mgmt-sftp-subnet.id}"
  azurerm_location       = "UK South"
  boot_diagnostics_storage_endpoint = "https://blob.windows~~~"
  image_uri              = "PACKER IMAGE BUILD OUTPUT"
  os_disk_storage_endpoint = "https://blob.windows~~~"
  rg_name                = "keving-sftp-test-rg"
  subnet_id              = "SOME SUBNET ID"
}
