module "sftp" {
  source                      = "git::git@github.com:hmcts/moj-module-sftp?ref=master"
  admin_username               = "${var.admin_username}"
  admin_password               = "${var.admin_password}"
  subnet_id                    = "${azurerm_subnet.mgmt-sftp-subnet.id}"
  resource_group_name          = "${azurerm_resource_group.mgmt.name}"
  subnet_id              = "SOME SUBNET ID"
}
