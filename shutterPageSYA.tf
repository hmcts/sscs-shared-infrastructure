//module "shutterPageSYA" {
//  source               = "git@github.com:hmcts/moj-module-shutterpage?ref=CNP-585"
//  location             = "${azurerm_resource_group.rg.location}"
//  env                  = "${var.env}"
//  resource_group_name  = "${azurerm_resource_group.rg.name}"
//  shutterPageDirectory = "${var.shutterPageDirectory}/sya"
//  tag_list             = "${var.common_tags}"
//  product              = "${var.product}-tribunals-frontend"
//  subscription         = "${var.subscription}"
//  shutterCustomDomain  = "${replace(var.product, "-tribunals-frontend", "")}"
//}
//
