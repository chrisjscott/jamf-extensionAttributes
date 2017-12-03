#!/bin/sh
# written by C. Scott on Nov. 2016
#
# This script checks ~/Library/Application Support/SketchUp 2016/liclog.txt
# When in trial mode, there's a line towards the end of the file that says "Is trial"
# When registered, that line says "Not trial"
#
# We then populate the system's "SW: SketchUp Registration Status" extension attribute
# We're also including the app version installed (since we're already capturing the most-recently installed version)
#
# This script would return a blank result if a) SketchUp isn't installed (obviously) or if the user is not
# logged in during inventory update (because it will use 'root' as the shortName)
# We get around this issue by acquiring the 'lastUserName' as per this article:
# https://www.jamf.com/jamf-nation/discussions/12769/getting-the-currently-logged-in-user#responseChild74509

shortName=`defaults read /Library/Preferences/com.apple.loginwindow.plist lastUserName`
licenseFilePath="/Users/$shortName/Library/Application Support/"
latestInstalledVersion=$( ls "$licenseFilePath" | grep SketchUp.20[0-9][0-9] | tail -n 1 )

if [ -f "$licenseFilePath$latestInstalledVersion"/liclog.txt ]; then
   if grep -q 'Is trial' "$licenseFilePath$latestInstalledVersion"/liclog.txt; then
         echo "<result>Trial ("${latestInstalledVersion:9}")</result>"
      else
         if grep -q 'Not trial' "$licenseFilePath$latestInstalledVersion"/liclog.txt; then
            echo "<result>Registered ("${latestInstalledVersion:9}")</result>"
         fi
   fi
fi
