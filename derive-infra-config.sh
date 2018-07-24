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
# Because pipeline sh() invocations do not pass environment variables back into
# the pipeline (even if exported) we have to go via an intermediate file, hence
# the somewhat odd echo stuff.
#
# It draws heavily on moj-infrastructure-bootstrap/bootstrap.sh

# Debug, output commands.
set -x

EXPORT_PREFIX="env."
AZURE_CONFIG_DIR="/opt/jenkins/.azure-$SUBSCRIPTION"

export az_keyVault_name=infra-vault-nonprod
export subscription_id=`az account show --query [id] -o tsv`

echo ${EXPORT_PREFIX}TF_VAR_vault_uri="https://infra-vault-${ENVIRONMENT}.vault.azure.net/"
echo ${EXPORT_PREFIX}TF_VAR_buildlog_sa_name="mgmtbuildlogstore${ENVIRONMENT}"
echo ${EXPORT_PREFIX}TF_VAR_buildlog_sa_key=`az storage account keys list --subscription ${subscription_id} --account-name ${TF_VAR_buildlog_sa_name} --resource-group mgmt-buildlog-store-${ENVIRONMENT} --output tsv | awk 'NR==1{ print \$3  }'`
echo ${EXPORT_PREFIX}TF_VAR_consulclustersjson=`az keyvault secret show --vault-name ${az_keyVault_name} --name cfg-jenkins-dnsforward --query value`

echo ${EXPORT_PREFIX}diagnosticstore=`az keyvault secret show --vault-name ${az_keyVault_name} --name cfg-log-store --query value`



