// Terraform variables which are environment specific

// Existing resource group and vnet where to create the sftp server
sftp_existing_vnet_name = "core-infra-vnet-sprod"
sftp_existing_resgroup_name = "core-infra-sprod"

// Manually allocated range for this subnet as part of "core-infra-vnet-sprod" = ["192.100.0.0" - "192.100.63.254"]
sftp_subnet_range = "10.100.63.0/24"

// Packer image for sftp system image
sftp_packer_image_name = "sscs-sftp-packer-image-1536935717"

// vault
infra_vault_resgroup = "cnp-core-infra"
