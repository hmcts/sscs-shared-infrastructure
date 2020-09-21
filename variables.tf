variable "product" {
  default     = "sscs"
  description = "The name of your application"
}

variable "env" {
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "location" {
  default = "UK South"
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

variable "ilbIp" {}

variable "tenant_id" {
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}

variable "managed_identity_object_id" {
  default = ""
}
