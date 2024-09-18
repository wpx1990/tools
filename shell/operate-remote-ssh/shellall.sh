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

operation=$2

operate_orin(){
    echo "###########orin#################"
    echo "star1-orin01:"
    ssh root@$star1orin01 $operation
    echo "star1-orin02:"
    ssh root@$star1orin02 $operation
    echo "star1-orin03:"
    ssh root@$star1orin03 $operation
    echo "star2-orin01:"
    ssh root@$star2orin01 $operation
    echo "star2-orin02:"
    ssh root@$star2orin02 $operation
    echo "star2-orin03:"
    ssh root@$star2orin03 $operation
    echo "star3-orin01:"
    ssh root@$star3orin01 $operation
    echo "star4-orin01:"
    ssh root@$star4orin01 $operation
    echo "################################"
}

operate_fpga(){
    echo "###########fpga#################"
    echo "star1-fpga:"
    ssh root@$star1fpga00 $operation
    echo "star2-fpga:"
    ssh root@$star2fpga00 $operation
    echo "star3-fpga:"
    ssh root@$star3fpga00 $operation
    echo "star4-fpga:"
    ssh root@$star4fpga00 $operation
    echo "################################"
}

if [ $1 = "orin" ];then
    operate_orin
elif [ $1 = "fpga" ];then
    operate_fpga
elif [ $1 = "all" ];then
    operate_orin
    operate_fpga
else
   echo "not support"
fi