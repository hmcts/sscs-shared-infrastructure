# SFTP for SSCS

This was initially created for ticket RDO-1567 which captures the issue that
SSCS in CNP is still reliant on SFTP servers in Tactical, which needed to be

The pipeline uses an external groovy code file to derive required secrets etc
from the provided run-time parameters of the job, this is only in a separate
file because it makes the primary pipeline cleaner, there is no functional
reason why it shouldn't be in there, except perhaps portability as below.

It leverages a terraform module repo which in turn leverages an ansible role
repo to create the instance.

# Requirements.

Build procedure requires bash, jq, and the azure CLI to be installed and
configured for all available subscriptions on the Jenkins agent box. Config
files for each environment should be in the place they are expected by the
config derivation script.

It requires packer-generated VM temlates to exist in azure, and in the RG/SA
that is configured in the derived config script. See also the repository
moj-infrastructure-bootstrap.

# Rationale

One of our software projects required SFTP servers with very particular protocol
version support, and on a fixed IP address for receiving updates from an
external supplier, but since the new platform does not readily support this
we needed to port our config from the old platform, and spin it up on standard
cloud instances in the appropriate security constructs.

## SSH Keys

SSH keys for managing the server are installed in the packer images. Keys have
to be manually generated and manually added to Azure vault named
"infra-vault-${subscription}" and the two keys are secrets called
"sscs-sftp-admin-public-key-${environment}" and
"sscs-sftp-admin-private-key-${environment}". The packer job will get this
keypair from vault and installs this key as authorized so Ansible can connect
to the VM after they are provisioned. The private key in Azure Key Vault has to
be stored as base64 encoded using "base64 -w0" as got problems with newlines
when the private key is stored in the original text format.

# License

MIT

# Author

Reform DevOps, HMCTS.
