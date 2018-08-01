# sscs-shared-infrastructure

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

# Rationale

One of our software projects required SFTP servers with very particular protocol
version support, and on a fixed IP address for receiving updates from an
external supplier, but since the new platform does not readily support this
we needed to port our config from the old platform, and spin it up on standard
cloud instances in the appropriate security constructs.

# Extending

You could take the derived-infra-config.groovy file from here and use it in 
another pipeline if there were such variables required by it for terraform.
This could be leveraged to spin up new types of infrastructure other than SFTP
servers.

# License

MIT

# Author 

Reform DevOps, HMCTS.
