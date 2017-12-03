#!/bin/sh
# Simple script to store battery's reported health - useful for proactively monitoring battery condition.
# See here for definitions of possible states: https://support.apple.com/en-us/HT204054#battery

batteryHealth=$(/usr/sbin/system_profiler -xml SPPowerDataType -detailLevel mini | grep -A 1 \<\key\>\sppower_battery_health\<\/\key\>  | awk '/string/' | sed 's/.*<string>\(.*\)<\/string>.*/\1/')

if [ "$batteryHealth" == "" ]; then
   echo "<result>Not present</result>"
else
   echo "<result>$batteryHealth</result>"
fi
