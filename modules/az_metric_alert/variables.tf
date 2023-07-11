variable "resourcegroup_name" {
  description = "The name of the azure resource group"
}
variable "arm_deployment_name" {
  description = "The name for the arm deployment"
}

variable "action_groups_external_id" {
  description = "The id for the action group"
}
variable "alert_description" {
  description = "The description that appears on the alert email"
}
variable "alert_evaluation_frequency" {
  description = "How often the alert rule should run"
}
variable "alert_query" {
  description = "The kusto query"
}
variable "alert_severity" {
  description = "The alert severity | 0 - Critical | 1 - Error | 2 - Warning | 3 - Informational | 4 - Verbose"
}
variable "alert_window_size" {
  description = "The interval over which alerts are collected"
}
variable "location" {
  description = "The location to create the alert"
}
variable "scheduled_query_rules_name" {
  description = "The name to give to the log search alert rule (lsar)"
}
variable "storage_accounts_external_id" {
  description = "The id for the storage account to query"
}
