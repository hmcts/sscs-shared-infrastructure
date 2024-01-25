# Create metric alert.
module "metric-alert" {
  depends_on          = [module.sscs-fail-action-group, azurerm_monitor_diagnostic_setting.mds1, azurerm_monitor_diagnostic_setting.mds2]
  source              = "./modules/az_metric_alert"
  resourcegroup_name  = azurerm_resource_group.rg.name
  arm_deployment_name = "sscs-fail-alert-sscssftp-email"

  # ARM parameters
  action_groups_external_id    = "/subscriptions/${var.subscription}/resourceGroups/${azurerm_resource_group.rg.name}/providers/microsoft.insights/actionGroups/${module.sscs-fail-action-group.action_group_name}"
  alert_description            = "The following storage account / blob has been updated:\n\n'sscssftpprod\\upload\\incoming\\failed'"
  alert_evaluation_frequency   = "PT5M"
  alert_query                  = "StorageBlobLogs | where TimeGenerated > ago(5m) | where OperationName == 'PutBlob' | where ObjectKey has \"upload/incoming/failed\""
  alert_severity               = "2"
  alert_window_size            = "PT5M"
  location                     = azurerm_resource_group.rg.location
  scheduled_query_rules_name   = "sscs-fail-alert-sscssftp-email"
  storage_accounts_external_id = "/subscriptions/${var.subscription}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Storage/storageAccounts/${module.sftp_storage.storageaccount_name}"
  common_tags                  = var.common_tags

}
