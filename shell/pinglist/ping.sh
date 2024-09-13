#!/bin/bash
echo ---------------------------Start ping----------------------------
for i in `cat ./iplist.txt`
do
    code=`ping -c 4 -W 3 $i|grep loss|awk '{print $6}'|awk -F "%" '{print $1}'`
if [ $code -eq 100 ];then
    echo -e "\033[31m ping  $i \t Fail  \t\t packet loss: %$code \033[0m"
else
    echo -e "\033[32m ping  $i \t Success \t packet loss: %$code \033[0m"
fi
done
echo ------------------------------Done-------------------------------