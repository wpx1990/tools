#!/bin/bash

time=`cat /proc/uptime`
msg=`echo $time| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("already run：%d day %d hour %d min %d sec\n",run_days,run_hour,run_minute,run_second)}'`

echo $msg
