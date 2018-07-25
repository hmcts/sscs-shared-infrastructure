#!groovy

 def az = { cmd -> return sh(script: "env AZURE_CONFIG_DIR=/opt/jenkins/.azure-$subscription az $cmd", returnStdout: true).trim() }

 env.az_keyVault_name = "infra-vault-nonprod"
 subscription_id = az "account show --query [id] -o tsv"
 env.TF_VAR_vault_uri = "https://infra-vault-${environment}.vault.azure.net/"
 env.TF_VAR_buildlog_sa_name = "mgmtbuildlogstore${environment}"
 env.TF_VAR_buildlog_sa_key = az "storage account keys list --subscription ${subscription_id} --account-name ${env.TF_VAR_buildlog_sa_name} --resource-group mgmt-buildlog-store-${environment} --output tsv | awk 'NR==1{ print \$3  }'"
 env.TF_VAR_consulclustersjson = az "keyvault secret show --vault-name \"${env.az_keyVault_name}\" --name cfg-jenkins-dnsforward --query value"
 dg = az "keyvault secret show --vault-name \"${env.az_keyVault_name}\" --name cfg-log-store | jq -r .rg_name"
 dg_name = "${dg}-${environment}"
 env.TF_VAR_diagnostics_sa_endpoint = "https://${dg_name}.blob.core.windows.net"

 env.TF_VAR_github_apikey = az "keyvault secret show --vault-name \"${env.az_keyVault_name}\" --name github-apikey"
 env.TF_VAR_github_enterprise_apikey = az "keyvault secret show --vault-name \"${env.az_keyVault_name}\" --name github-enterprise-apikey"
 env.TF_VAR_hashicorp_vault_token = az "keyvault secret show --vault-name \"${env.az_keyVault_name}\" --name hashicorp-vault-token"
 env.TF_VAR_hmcts_github_apikey = az "keyvault secret show --vault-name \"${env.az_keyVault_name}\" --name hmcts-github-apikey"
