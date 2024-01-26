A module that lets you create custom query alerts against a storage account.
## Variables

### Configuration

All parameters are required by this module

- `action_groups_external_id` The id for the action group
- `alert_description` The description that appears on the alert email
- `alert_evaluation_frequency` How often the alert rule should run
- `alert_query` The kusto query
- `alert_severity` The alert severity | 0 - Critical | 1 - Error | 2 - Warning | 3 - Informational | 4 - Verbose
- `alert_window_size` The interval over which alerts are collected
- `location` The location to create the alert
- `scheduled_query_rules_name` The name to give to the log search alert rule
- `storage_accounts_external_id` The id for the storage account to query

### Output

None

## Usage

The following example shows how to use the module.

```terraform
# Create metric alert.

module "metric-alert" {
  depends_on          = [module.sscs-fail-action-group, azurerm_monitor_diagnostic_setting.mds1, azurerm_monitor_diagnostic_setting.mds2]
  source              = "./modules/az_metric_alert"
  resourcegroup_name  = azurerm_resource_group.rg.name
  arm_deployment_name = "sscs-fail-alert-sscssftpprod-email"

  # ARM parameters
  action_groups_external_id    = "/subscriptions/${var.subscription}/resourceGroups/${azurerm_resource_group.rg.name}/providers/microsoft.insights/actionGroups/${module.sscs-fail-action-group.action_group_name}"
  alert_description            = "The following storage account / blob has been updated:\n\n'sscssftpprod\\upload\\incoming\\failed'"
  alert_evaluation_frequency   = "PT5M"
  alert_query                  = "StorageBlobLogs | where TimeGenerated > ago(5m) | where OperationName == 'PutBlob' | where ObjectKey has \"upload/incoming/failed\""
  alert_severity               = "2"
  alert_window_size            = "PT5M"
  location                     = azurerm_resource_group.rg.location
  scheduled_query_rules_name   = "sscs-fail-alert-sscssftpprod-email"
  storage_accounts_external_id = "/subscriptions/${var.subscription}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Storage/storageAccounts/${module.sftp_storage.storageaccount_name}"

}
```
