variable "appinsights_location" {
  type        = "string"
  default     = "West Europe"
  description = "Location for Application Insights"
}

variable "appinsights_application_type" {
  type        = "string"
  default     = "Web"
  description = "Type of Application Insights (Web/Other)"
}
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-${var.env}"
  location            = "${var.appinsights_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  application_type    = "${var.appinsights_application_type}"
}

output "appInsightsInstrumentationKey" {
  value = "${azurerm_application_insights.appinsights.instrumentation_key}"
}