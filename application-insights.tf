variable "appinsights_application_type" {
  default     = "web"
  description = "Type of Application Insights (Web/Other)"
}
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-${var.env}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = var.appinsights_application_type
}

resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "AppInsightsInstrumentationKey"
  value        = azurerm_application_insights.appinsights.instrumentation_key
  key_vault_id = module.sscs-vault.key_vault_id
}

output "appInsightsInstrumentationKey" {
  sensitive = true
  value     = azurerm_application_insights.appinsights.instrumentation_key
}
