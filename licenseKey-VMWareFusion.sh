#!/bin/sh
# written by C. Scott on Nov. 2016
#
# This script checks for the existence of a VMware Fusion directory - if one exists then
# it selects the latest version's license file and outputs the serial number and version.
#
# 18.02.09: added '-tr' flag to ls command to ensure that most recent license file is used

licenseFilePath="/Library/Preferences/VMware Fusion"

if [ -d "$licenseFilePath" ]; then
   latestLicenseFile=$(ls -tr "$licenseFilePath"/license-fusion-* | tail -n 1)

   sn=`cat "$latestLicenseFile" | grep "Serial =" | awk '{print $3}' | sed 's/"//g'`
   version=`cat "$latestLicenseFile" | grep "LicenseVersion =" | awk '{print $3}' | sed 's/"//g'`

   echo "<result>$sn (v$version)</result>"
fi
