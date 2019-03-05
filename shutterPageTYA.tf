module "shutterPageTYA" {
  source               = "git@github.com:hmcts/moj-module-shutterpage?ref=CNP-585"
  location             = "${azurerm_resource_group.rg.location}"
  env                  = "${var.env}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  shutterPageDirectory = "${var.shutterPageDirectory}/tya"
  tag_list             = "${var.common_tags}"
  product              = "${var.product}-tya-frontend"
  subscription         = "${var.subscription}"
}
