module "SYAshutterPage" {
    source                = "git@github.com:hmcts/moj-module-shutterpage?ref=master"
    location              = "${azurerm_resource_group.rg.location}"
    env                   = "${var.env}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    shutterPageDirectory  = "${var.shutterPageDirectory}/sya"
    tag_list              = "${local.common_tags}"
    product               = "${var.product}"
    subscription          = "${var.subscription}"
    shutterCustomDomain   = "${var.product}"
}

module "TYAshutterPage" {
    source                = "git@github.com:hmcts/moj-module-shutterpage?ref=master"
    location              = "${azurerm_resource_group.rg.location}"
    env                   = "${var.env}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    shutterPageDirectory  = "${var.shutterPageDirectory}/tya"
    tag_list              = "${local.common_tags}"
    product               = "${var.product}"
    subscription          = "${var.subscription}"
    shutterCustomDomain   = "${var.product}"
}

module "CORshutterPage" {
    source                = "git@github.com:hmcts/moj-module-shutterpage?ref=master"
    location              = "${azurerm_resource_group.rg.location}"
    env                   = "${var.env}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    shutterPageDirectory  = "${var.shutterPageDirectory}/cor"
    tag_list              = "${local.common_tags}"
    product               = "${var.product}"
    subscription          = "${var.subscription}"
    shutterCustomDomain   = "${var.product}"
}

