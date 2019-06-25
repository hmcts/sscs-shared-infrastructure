variable "product" {
  type        = "string"
  default     = "sscs"
  description = "The name of your application"
}

variable "env" {
  type        = "string"
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "location" {
  type    = "string"
  default = "UK South"
}

variable "shutterPageDirectory" {
    type    = "string"
    default = "shutterPages"
}

// TAG SPECIFIC VARIABLES
variable "common_tags" {
  type = "map"
}

variable "tribunals_frontend_external_cert_name" {}

variable "tribunals_frontend_external_hostname" {}

variable "external_cert_vault_uri" {}

variable "ilbIp" {}

variable "subscription" {}

variable "tenant_id" {
  type        = "string"
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  type        = "string"
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}
