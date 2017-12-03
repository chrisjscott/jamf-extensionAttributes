#!/bin/bash
# CScott: simple script to store the version of SentinelOne

s1Version=`sudo /usr/local/bin/sentinelctl version`

if [[ "$s1Version" == "Sentinel"* ]]
then
    echo "<result>$s1Version</result>"
else
    echo "<result>not installed</result>"
fi
