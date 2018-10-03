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

variable "team_name" {
  type        = "string"
  description = "Team name"
  default     = "SSCS"
}

variable "team_contact" {
  type        = "string"
  description = "Team contact"
  default     = "#sscs-sta"
}

variable "destroy_me" {
  type        = "string"
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}
