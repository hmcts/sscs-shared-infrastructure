
module "application_insights" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=4.x"

  env                 = var.env
  product             = var.product
  name                = var.product
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  alert_limit_reached = true

  common_tags = local.tags
  
  # Capture full telemetry on the lower environments used for diagnosis (aat)
  # so failures (failed requests, 5xx, exceptions) are not dropped by the module's default
  # non-prod ingestion sampling of 1%, which blocks diagnosis. Remaining environments keep the
  # module defaults (prod = 100%, other non-prod = 1%)
  sampling_percentage = contains(["aat"], lower(var.env)) ? 25 : null
}


moved {
  from = azurerm_application_insights.appinsights
  to   = module.application_insights.azurerm_application_insights.this
}

resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "AppInsightsInstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = module.sscs-vault.key_vault_id

  content_type = "terraform-managed,service-bus"
  tags = merge(local.tags, {
    "source" : "Service Bus ${module.servicebus-namespace.name}"
  })
}

output "appInsightsInstrumentationKey" {
  sensitive = true
  value     = module.application_insights.instrumentation_key
}

resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "app-insights-connection-string"
  value        = module.application_insights.connection_string
  key_vault_id = module.sscs-vault.key_vault_id
}
