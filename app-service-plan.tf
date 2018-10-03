locals {
  ase_name = "core-compute-${var.env}"
  asp_name_without_env = "${var.product}"

  asp_capacity = "1"
  asp_sku_size = "I1"
}

module "sscs_app_service_plan" {
  source              = "git@github.com:hmcts/cnp-module-app-service-plan?ref=master"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  env                 = "${var.env}"
  ase_name            = "${local.ase_name}"
  asp_name            = "${local.asp_name_without_env}"
  asp_capacity        = "${local.asp_capacity}"
  asp_sku_size        = "${local.asp_sku_size}"
  tag_list            = "${local.tags}"
}

output "appServicePlan" {
  value = "${local.asp_name_without_env}-${var.env}"
}

output "appServiceCapacity" {
  value = "${local.asp_capacity}"
}

output "appServiceSkuSize" {
  value = "${local.asp_sku_size}"
}