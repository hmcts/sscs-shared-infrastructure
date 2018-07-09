variable "product" {
  type = "string"
  default = "sscs"
}

variable "location" {
  type    = "string"
  default = "UK South"
}

// as of now, UK South is unavailable for Application Insights
//variable "appinsights_location" {
//  type        = "string"
//  default     = "West Europe"
//  description = "Location for Application Insights"
//}

variable "env" {
  type = "string"
}

//variable "application_type" {
//  type        = "string"
//  default     = "Web"
//  description = "Type of Application Insights (Web/Other)"
//}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environemnt variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}
variable "azurerm_location" {
  default = "UK South"
  type    = "string"
}

variable "admin_username" {
  type = "string"
}

variable "admin_password" {
  type = "string"
}

variable "prefix_env" {
  type        = "string"
  default     = "mgmt"
}

# potential values: dev, test, qa, prod
variable "env" {
  type        = "string"
}

variable "vm_image_uri" {
  description = "Uri of the disk to be used"
  type        = "string"
}

variable "vm_image_id" {
  description = "Subscription ID of disk image"
  type        = "string"
}

variable "diagnostics_sa_endpoint" {
  type = "string"
}

variable "resource_group_name" {
  type    = "string"
}

variable "subnet_id" {
  type    = "string"
}

variable "subnet_name" {
  type    = "string"
}

variable "virtual_network" {
  type    = "string"
}

variable "subnet_rg" {
  type    = "string"
}

variable "vm_name" {
  default = "sftp"
  type    = "string"
}

variable "vm_size" {
  default = "Standard_D4s_v3"
  type    = "string"
}

variable "datadisk_storage_type" {
  default = "Premium_LRS"
  type    = "string"
}

variable "datadisk_size" {
  default = "200"
  type    = "string"
}

variable "sftp_home" {
  default = "/opt/sftp"
  type    = "string"
}

variable "sftp_storage_acct" {
  default = "mgmtvmimgstorelpdev"
  type    = "string"
}

variable "ssh_pub_key" {
  description = "ssh public key to configure the bastion"
}

variable "ssh_priv_key" {
  description = "ssh private key used for connecting on the bastion"
}

variable "resourcegroup_name" {
  description = "Name for the azure resource group for the mamagement area"
  type        = "string"
}

variable "playbook_repo" {
  default = "git@github.com:contino/moj-sftp-config.git"
}

variable "moj_sftp_dns_repo" {
  default = "git@github.com:contino/moj-sftp-dns.git"
}

variable "github_apikey" {}

variable "hmcts_github_apikey" {}

variable "github_enterprise_apikey" {}

variable "sftp_subscription_id" {}

variable "sftp_tenant_id" {}

variable "sftp_client_id" {}

variable "sftp_client_secret" {}

variable "sftp_ssh_priv_key" {}
variable "sftp_ssh_authorized_key" {}

variable "sftp_agent_password" {}

variable "consulclustersjson" {}

variable "tactical_dns_ip" {}

variable "root_address_space" {}

variable "microsoft_external_dns" {
  type = "list"
  default     = ["168.63.129.16"]
  description = "List of external DNS servers, default currently including tactical dns."
}

variable "sonar_api_key" {}

variable "slack_token" {}

variable "hashicorp_vault_token" {}

variable "pipelinemetrics_cosmosdb_key" {}

variable "owaspdb_password" {}

variable "buildlog_sa_name" {}
variable "buildlog_sa_key" {}
