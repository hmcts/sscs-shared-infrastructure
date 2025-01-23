# Get log analytics workspace name.
module "log_analytics_workspace" {
  source      = "git@github.com:hmcts/terraform-module-log-analytics-workspace-id?ref=master"
  environment = var.env
}

# Connect to log analytics - create storage account root diagnostic setting.
resource "azurerm_monitor_diagnostic_setting" "mds1" {
  name                       = "diag-storageaccountroot"
  target_resource_id         = module.sftp_storage.storageaccount_id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id
  metric {
    category = "Transaction"
    retention_policy {
      enabled = true
    }
  }
  lifecycle {
    ignore_changes = [
      metric
    ]
  }
}

# Connect to log analytics - create storage account blob diagnostic setting.
resource "azurerm_monitor_diagnostic_setting" "mds2" {
  name                       = "diag-storageaccountblob"
  target_resource_id         = "${module.sftp_storage.storageaccount_id}/blobServices/default/"
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id
  enabled_log {
    category = "StorageRead"
    retention_policy {
      enabled = true
    }
  }
  enabled_log {
    category = "StorageWrite"
    retention_policy {
      enabled = true
    }
  }
  enabled_log {
    category = "StorageDelete"
    retention_policy {
      enabled = true
    }
  }
  metric {
    category = "Transaction"
    retention_policy {
      enabled = true
    }
  }
  lifecycle {
    ignore_changes = [
      metric
    ]
  }
}