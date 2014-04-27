#!/bin/bash

TEMP=$(cat $1 | grep t= | awk 'NF>1{print $NF}' | sed -r 's/t=//g')
TIME=$(date +%s)
mongo mydb --eval "db.testData.insert({\"value\":\"$TEMP\", \"timestamp\": \"$TIME\", \"sensor\": \"$1\"})"