#!/bin/bash

star1orin01=10.112.4.2
star1orin02=10.112.4.3
star1orin03=10.112.4.4
star1fpga00=10.112.4.5
star2orin01=10.112.5.2
star2orin02=10.112.5.3
star2orin03=10.112.5.4
star2fpga00=10.112.5.5
star3orin01=10.112.6.2
star3fpga00=10.112.6.3
star4orin01=10.112.7.2
star4fpga00=10.112.7.3

local_file=$2
remote_file=$3

scp_orin(){
    echo "###########orin#################"
    echo "star1-orin01:"
    scp -r $local_file $star1orin01:$remote_file
    echo "star1-orin02:"
    scp -r $local_file $star1orin02:$remote_file
    echo "star1-orin03:"
    scp -r $local_file $star1orin03:$remote_file
    echo "star2-orin01:"
    scp -r $local_file $star2orin01:$remote_file
    echo "star2-orin02:"
    scp -r $local_file $star2orin02:$remote_file
    echo "star2-orin03:"
    scp -r $local_file $star2orin03:$remote_file
    echo "star3-orin01:"
    scp -r $local_file $star3orin01:$remote_file
    echo "star4-orin01:"
    scp -r $local_file $star4orin01:$remote_file
    echo "################################"
}

scp_fpga(){
    echo "###########fpga#################"
    echo "star1-fpga:"
    scp -r $local_file $star1fpga00:$remote_file
    echo "star2-fpga:"
    scp -r $local_file $star2fpga00:$remote_file
    echo "star3-fpga:"
    scp -r $local_file $star3fpga00:$remote_file
    echo "star4-fpga:"
    scp -r $local_file $star4fpga00:$remote_file
    echo "################################"
}

if [ $1 = "orin" ];then
    scp_orin
elif [ $1 = "fpga" ];then
    scp_fpga
elif [ $1 = "all" ];then
    scp_orin
    scp_fpga
else
   echo "not support"
fi