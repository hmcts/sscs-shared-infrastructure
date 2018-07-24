#!/bin/bash
#
# This script is to take the jenkins job parameters of PRODUCT_NAME, 
# ENVIRONMENT, and SUBSCRIPTION, and use azure CLI commands and vault lookups
# to derive the settings we need to spin up the SFTP infrastructure.
#
# This stuff was moved into a supporting script because otherwise there is
# too much clutter in the jenkins pipeline file, and because shell supports
# the required commands much more directly, with less need to shoehorn them in.
#
# It draws heavily on moj-infrastructure-bootstrap/bootstrap.sh

alias az-env "env AZURE_CONFIG_DIR=/opt/jenkins/.azure-$SUBSCRIPTION az"

az_keyVault_name="infra-vault-nonprod"
export subscription_id=`az-env account show --query [id] -o tsv`
export TF_VAR_vault_uri="https://infra-vault-${ENVIRONMENT}.vault.azure.net/"
export TF_VAR_buildlog_sa_name="mgmtbuildlogstore${ENVIRONMENT}"
export TF_VAR_buildlog_sa_key=`az-env storage account keys list --subscription ${subscription_id} --account-name ${TF_VAR_buildlog_sa_name} --resource-group mgmt-buildlog-store-${ENVIRONMENT} --output tsv | awk 'NR==1{ print \$3  }'`
export TF_VAR_consulclustersjson=`az-env keyvault secret show --vault-name \"${az_keyVault_name}\" --name cfg-jenkins-dnsforward --query value`

diagnosticstore=`az-env keyvault secret show --vault-name \"${az_keyVault_name}\" --name cfg-log-store --query value`



