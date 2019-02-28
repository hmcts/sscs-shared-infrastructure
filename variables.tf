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