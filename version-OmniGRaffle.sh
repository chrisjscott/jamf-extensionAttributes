#!/bin/sh
# written by C. Scott on Nov. 2016
#
# This script checks for the existence of an OmniGraffle-*.omnilicense file and extracts the registered serial number.
# Currently looks for licenses for v5, 6 and 7. Does not distinguish Standard app from Pro app.
#
# This script will return a blank result if any version of OmniGraffle is installed but not registered.
#
# Since JAMF Pro runs scripts as root, we ensure that we're captuing the actual user's short name as per this article:
# https://www.jamf.com/jamf-nation/discussions/12769/getting-the-currently-logged-in-user#responseChild74509

shortName=$(defaults read /Library/Preferences/com.apple.loginwindow.plist lastUserName)
licenseFilePath5="/Users/$shortName/Library/Application Support/Omni Group/Software Licenses"
licenseFilePath6="/Users/$shortName/Library/Containers/com.omnigroup.OmniGraffle6/Data/Library/Application Support"
licenseFilePath6MAS="/Users/$shortName/Library/Containers/com.omnigroup.OmniGraffle6.MacAppStore/Data/Library/Application Support"
licenseFilePath7="/Users/$shortName/Library/Containers/com.omnigroup.OmniGraffle7/Data/Library/Application Support"
licenseFilePath7MAS="/Users/$shortName/Library/Containers/com.omnigroup.OmniGraffle7.MacAppStore/Data/Library/Application Support"

if [ -f "$licenseFilePath5"/OmniGraffle*.omnilicense ]; then
   result5="$( cat "$licenseFilePath5"/OmniGraffle*.omnilicense | grep -A 1 Key | grep string | sed 's/<string>//g' | sed 's/<\/string>//g' | awk '{print $1}' ) (v5)"
fi

if [ -f "$licenseFilePath6"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense ]; then
   result6="$( cat "$licenseFilePath6"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense | grep -A 1 Key | grep string | sed 's/<string>//g' | sed 's/<\/string>//g' | awk '{print $1}' ) (v6)"
fi

if [ -f "$licenseFilePath6MAS"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense ]; then
   result6MAS="$( cat "$licenseFilePath6MAS"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense | grep -A 1 Key | grep string | sed 's/<string>//g' | sed 's/<\/string>//g' | awk '{print $1}' ) (v6-MAS)"
fi

if [ -f "$licenseFilePath7"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense ]; then
   result7="$( cat "$licenseFilePath7"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense | grep -A 1 Key | grep string | sed 's/<string>//g' | sed 's/<\/string>//g' | awk '{print $1}' ) (v7)"
fi

if [ -f "$licenseFilePath7MAS"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense ]; then
   result7MAS="$( cat "$licenseFilePath7MAS"/Omni\ Group/Software\ Licenses/OmniGraffle*.omnilicense | grep -A 1 Key | grep string | sed 's/<string>//g' | sed 's/<\/string>//g' | awk '{print $1}') (v7-MAS)"
fi

if [ ! -z "$result5" ]; then
   result="$result5"
fi

if [ ! -z "$result6" ]; then
   if [ ! -z "$result" ]; then
      result="$result<br>$result6"
   else
      result="$result6"
   fi
fi

if [ ! -z "$result6MAS" ]; then
   if [ ! -z "$result" ]; then
      result="$result<br>$result6MAS"
   else
      result="$result6MAS"
   fi
fi
if [ ! -z "$result7" ]; then
   if [ ! -z "$result" ]; then
      result="$result<br>$result7"
   else
      result="$result7"
   fi
fi

if [ ! -z "$result7MAS" ]; then
   if [ ! -z "$result" ]; then
      result="$result<br>$result7MAS"
   else
      result="$result7MAS"
   fi
fi

echo "<result>$result</result>"
