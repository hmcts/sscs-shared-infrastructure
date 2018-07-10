
resource "azurerm_virtual_network" "mgmt-vnet" {
  name                = "${var.prefix_env}-infra-${var.env}"
  address_space       = ["${cidrsubnet("${var.root_address_space}", 6, "${var.env == "prod" ? 0 : 15}")}"]
  location            = "${var.azurerm_location}"
  dns_servers         = ["127.0.0.1", "${var.microsoft_external_dns}"]
  resource_group_name = "${azurerm_resource_group.mgmt.name}"
}

resource "azurerm_resource_group" "mgmt" {
  name                          = "${var.prefix_env}-${var.resourcegroup_name}-${var.env}"
  location                      = "${var.azurerm_location}"
}


resource "azurerm_subnet" "mgmt-sftp-subnet" {
  name                 = "sftp-subnet"
  resource_group_name  = "${azurerm_resource_group.mgmt.name}"
  virtual_network_name = "${azurerm_virtual_network.mgmt-vnet.name}"
  address_prefix       = "${cidrsubnet("${element(azurerm_virtual_network.mgmt-vnet.address_space, 0)}", 4, 1)}"

  network_security_group_id = "${azurerm_network_security_group.mgmt-sftp-sg.id}"
}

resource "azurerm_network_security_group" "mgmt-sftp-sg" {
  name                = "${var.prefix_env}-sftp-sg-${var.env}"
  location            = "${var.azurerm_location}"
  resource_group_name = "${azurerm_resource_group.mgmt.name}"

  # TODO: Some security rules will be needed here later.

}
