module "sftp" {
  source                      = "git::git@github.com:hmcts/moj-module-sftp?ref=master"
  env                          = "${var.env}"
  admin_username               = "${var.admin_username}"
  admin_password               = "${random_string.admin_password.result}"
  subnet_id                    = "${azurerm_subnet.mgmt-sftp-subnet.id}"
  resource_group_name          = "${azurerm_resource_group.mgmt.name}"
  virtual_network              = "${azurerm_subnet.mgmt-sftp-subnet.virtual_network_name}"
  subnet_rg                    = "${azurerm_subnet.mgmt-sftp-subnet.resource_group_name}"
  hashicorp_vault_token        = "${var.hashicorp_vault_token}"

  vm_image_uri                 = "${var.vm_image_uri}"
  vm_image_id                  = "${var.vm_image_id}"

  sftp_client_id            = "${var.sftp_client_id}"
  sftp_tenant_id            = "${var.sftp_tenant_id}"
  sftp_client_secret        = "${var.sftp_client_secret}"
  sftp_subscription_id      = "${var.sftp_subscription_id}"
  sftp_ssh_priv_key      = "${var.sftp_ssh_priv_key}"
  sftp_ssh_authorized_key      = "${var.sftp_ssh_authorized_key}"

  diagnostics_sa_endpoint      = "${var.diagnostics_sa_endpoint}"
  subnet_name                  = "${azurerm_subnet.mgmt-sftp-subnet.name}"
  consulclustersjson           = "${var.consulclustersjson}"
  slack_token                  = "${var.slack_token}"
  pipelinemetrics_cosmosdb_key = "${var.pipelinemetrics_cosmosdb_key}"
  owaspdb_password             = "${var.owaspdb_password}"
  buildlog_sa_name             = "${var.buildlog_sa_name}"
  sonar_api_key                = "${var.sonar_api_key}"
  buildlog_sa_key              = "${var.buildlog_sa_key}"

}

