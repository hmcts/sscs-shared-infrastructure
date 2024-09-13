# sscs-shared-infrastructure

This repository contains the shared the common infra components for SSCS

### Metric Alerts

Secrets "sscs-failure-email-to" needs to be added to the 'sscs-&lt;env>' key-vault prior to pipeline run. 
If dead-letter-queue metric alerts are being added, secret "sscs-dead-letter-email-to" also needs to be added.
Secrets can be added as follows https://github.com/hmcts/cnp-module-key-vault#writing-secrets-to-key-vaults.

