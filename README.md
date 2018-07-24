# sscs-shared-infrastructure

This was initially created for ticket RDO-1567 which captures the issue that
SSCS in CNP is still reliant on SFTP servers in Tactical, which needed to be

It leverages local config files that are excluded from git commits in order to
retain secrecy over credentials etc, these will need to be created locally 
before use so that terraform doesn't choke.

# Requirements.

Build procedure requires bash, jq, and the azure CLI to be installed and
configured for all available subscriptions on the Jenkins agent box. Config
files for each environment should be in the place they are expected by the
config derivation script.

