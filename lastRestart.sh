#!/bin/sh
# CScott: simple script to store date & time of last reboot
# Useful when implementing a "It's been x days since you last rebooted" reminder policy

lastBootRaw=$(sysctl kern.boottime | awk '{print $5}' | sed 's/,$//')
lastBootFormat=$(date -jf "%s" "$lastBootRaw" +"%Y-%m-%d %T")

echo "<result>$lastBootFormat</result>"