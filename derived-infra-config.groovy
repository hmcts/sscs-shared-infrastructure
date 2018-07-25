#!groovy

 def az = { cmd -> return sh(script: "env AZURE_CONFIG_DIR=/opt/jenkins/.azure-$subscription az $cmd", returnStdout: true).trim() }

 env.az_keyvault_name = "infra-vault-nonprod"
 subscription_id = az "account show --query [id] -o tsv"
 env.TF_VAR_vault_uri = "https://infra-vault-${environment}.vault.azure.net/"
 env.TF_VAR_buildlog_sa_name = "mgmtbuildlogstore${environment}"
 env.TF_VAR_buildlog_sa_key = az "storage account keys list --subscription ${subscription_id} --account-name ${env.TF_VAR_buildlog_sa_name} --resource-group mgmt-buildlog-store-${environment} --output tsv | awk 'NR==1{ print \$3  }'"
 env.TF_VAR_consulclustersjson = az "keyvault secret show --vault-name \"${env.az_keyVault_name}\" --name cfg-jenkins-dnsforward --query value"

