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

output "appInsightsInstrumentationKey" {
  value = azurerm_application_insights.appinsights.instrumentation_key
}
