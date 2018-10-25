variable "product" {
  type        = "string"
  default     = "sscs"
  description = "The name of your application"
}

variable "location" {
  type    = "string"
  default = "uksouth"
}

variable "env" {
  type        = "string"
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "sftp_vm_size" {
  default = "Standard_D2_v2"
}

variable "sftp_disk_size_gb" {
  default = "100"
}

variable "sftp_subnet_range" {
  type = "string"
}

variable "sftp_packer_image_name" {
  type = "string"
}

variable "sftp_admin_username" {
  type = "string"
}

variable "sftp_existing_resgroup_name" {
  type = "string"
}

variable "sftp_existing_vnet_name" {
  type = "string"
}

variable "subscription_name" {
  type = "string"
}

variable "subscription_id" {
  type = "string"
}

variable "infra_vault_resgroup" {
  type = "string"
}
