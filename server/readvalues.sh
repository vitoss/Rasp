#!/bin/bash
TEMP=$(cat /sys/bus/w1/devices/$1/w1_slave | grep t= | awk 'NF>1{print $NF}' | sed -r 's/t=//g')
/usr/bin/sqlite3 /home/pi/Rasp/Rasp/server/database.db 'insert into temperature (temperature) values ('$TEMP'*1.0/1000);'
