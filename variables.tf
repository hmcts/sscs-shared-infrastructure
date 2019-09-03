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

variable "subscription" {}

// TAG SPECIFIC VARIABLES
variable "common_tags" {
  type = "map"
}

variable "tenant_id" {
  type        = "string"
  description = "The Tenant ID of the Azure Active Directory"
}

variable "jenkins_AAD_objectId" {
  type        = "string"
  description = "This is the ID of the Application you wish to give access to the Key Vault via the access policy"
}

variable "managed_identity_object_id" {
  default = ""
}
