# sscs-shared-infrastructure

This was initially created for ticket RDO-1567 which captures the issue that
SSCS in CNP is still reliant on SFTP servers in Tactical, which needed to be

It leverages local config files that are excluded from git commits in order to
retain secrecy over credentials etc, these will need to be created locally 
before use so that terraform doesn't choke.
