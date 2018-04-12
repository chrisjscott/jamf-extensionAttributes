#!/bin/sh
# written by C. Scott on Nov. 2016
# updated in March 2018 to include license expiration date
#
# This script checks ~/Library/Application Support/com.bohemiancoding.sketch3/.license
# When in trial mode, the payload definition in .license shows "status":"nok" and "type":"trial"
# When registered, the payload shows "status":"ok" and "type":"static"
# (FYI, it also adds "email":"<registeredEmailAddress>")
#
# I've chosen to test using the type value.
# We then populate the system's "SW: Sketch Registration Status" extension attribute
#
# Trial = app was downloaded from sketchapp.com but not purchased
# Registered = app was downloaded from sketchapp.com and purchased
# Mac App Store = app was purchased from the Mac App Store prior to its removal in Dec. 2015
#
# This script will return a blank result if a) Sketch isn't installed (obviously) or if the user is not
# logged in during inventory update (because it will use 'root' as the shortName)
# We get around this issue by acquiring the 'lastUserName' as per this article:
# https://www.jamf.com/jamf-nation/discussions/12769/getting-the-currently-logged-in-user#responseChild74509

shortName=`defaults read /Library/Preferences/com.apple.loginwindow.plist lastUserName`
licenseFile="/Users/$shortName/Library/Application Support/com.bohemiancoding.sketch3/.license"

if [ -f "$licenseFile" ]; then
   if grep -q 'type\":\"trial' "$licenseFile"; then
         echo "<result>Trial</result>"
      else
         if grep -q 'type\":\"static' "$licenseFile"; then
            emailAddress=`grep -o 'email.*\.[a-z]*' "$licenseFile" | cut -c9-`
            expirationDateEpoch=`grep -o '"expiration\"\:\"[0-9]*' "$licenseFile" | cut -c15-`
            expirationDate=`date -r $expirationDateEpoch +"%m-%d-%Y"`
            echo "<result>Registered to $emailAddress (expires on $expirationDate)</result>"
         fi
   fi
fi

if [ -d /Users/$shortName/Library/Containers/com.bohemiancoding.sketch3/Data/Library/Application\ Support/com.bohemiancoding.sketch3/MASReceipts ]; then
   echo "<result>Mac App Store purchase</result>"
fi
