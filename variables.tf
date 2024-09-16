variable "product" {
  default     = "sscs"
  description = "The name of your application"
}

variable "env" {
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "location" {
  default = "uksouth"
}

variable "businessArea" {
  default = "cft"
}


variable "shutterPageDirectory" {
  default = "shutterPages"
}

variable "subscription" {}

// TAG SPECIFIC VARIABLES
variable "common_tags" {
  type = map(string)
}

variable "tribunals_frontend_external_cert_name" {}

variable "tribunals_frontend_external_hostname" {}

variable "external_cert_vault_uri" {}

variable "tenant_id" {
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}

variable "sftp_access_AAD_objectId" {
  description = "Object ID of the group you wish to give access to the SFTP storage account via access policy"
}

variable "sftp_allowed_key_secrets" {
  description = "A list of names of public keys in the vault to allow access to"
  type        = list(string)
  default     = []
}

variable "managed_identity_object_id" {
  default = ""
}

variable "sftp_allowed_sa_subnets" {
  description = "Subnets allowed to access storage account"
  type        = list(string)
  default     = []
}

variable "aks_subscription_id" {}


#================================================================================================
# Monitor Variables
#================================================================================================
variable "monitor_action_group" {
  default = {}
}
variable "monitor_metric_alerts" {
  default = {}
}

variable "max_message_size_in_kilobytes" {
  type        = string
  description = "Integer value which controls the maximum size of a message allowed on the topic for Premium SKU"
  default     = null
}

variable "service_bus_sku" {
  default     = "Standard"
  description = "The SKU of service bus to use. Possible values are `Standard` and `Premium`."
}

variable "capacity" {
  default = 0
}

variable "zone_redundant" {
  default     = false
}