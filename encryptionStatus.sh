#!/bin/sh

# This script stores the results of 'fdesetup status'
# Useful if you're watching for unencrypted systems on your netwok and you want
# to avoid tagging systems that, though aren't encrypted, are in-progress.
#
# Note that diskutil no longer works as of 10.13
#
# Possible replies are:
# FileVault is Off.
#
# FileVault is Off.
# Deferred enablement appears to be active for user '<shortName>'.
#
# (after reboot)
#
# FileVault is On.
# Encryption in progress: percent completed = ##.##
# (note that JAMF still considers the volume to be unencrypted while "in progress")
#
# FileVault is On.
# Encryption in progress: Pending
# (this is when the system is not plugged in)
#
# FileVault is On.

status=$(fdesetup status)
echo "<result>$status</result>"
