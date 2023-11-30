#!/bin/bash

log_file_tail="-obersve-data.log"
last_alarm_time=0
min_alarm_time_interval=3600 #最小告警间隔时间，单位s

# 以下异常指标，则发告警
max_app_num=20 # app数量大于20
max_cpu_used_per=90 # 使用CPU大于90%，
max_load_average=10 # 1min的load_average大于10
max_mem_used_per=90 # 最大内存使用比例
max_swap_used_per=90 # 最大swap使用比例

server_name="10.11.9.97 "
web_hock='https://oapi.dingtalk.com/robot/send?access_token=8c85a266c187cc87aa5c628e2f7e7818c38d41df5ef74be2e967d1f9eb13e5ee'

post_alarm(){
	msg_body='{"msgtype": "text", "text": {"content": "'$*'"}}'
    curl $web_hock -H 'Content-Type: application/json' -d "$msg_body" >/dev/null 2>&1
}

observe_server(){
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
	current_date=$(echo $current_time | awk '{print $1}')
	LOG_FILE=$current_date$log_file_tail
    echo -e "-------------------------------------------------------------------" >> $LOG_FILE
    echo -e $current_time"\n" >> $LOG_FILE
    
    top -b -n 2 -d 0.01 | awk '/^top/{i++}i==2' | head -n 30 >> $LOG_FILE
    echo -e "\n" >> $LOG_FILE
    
    free -m >> $LOG_FILE
    echo -e "\n" >> $LOG_FILE
    
    # 读取当前各项指标的值
    
    # cluster进程的数量
    current_cluster_num=`ps -ef | grep Cluster | grep -v grep | wc -l`
    echo -e "cluster process num:\t" $current_cluster_num >> $LOG_FILE
    
    # app进程的数量
    current_app_num=`ps -ef | grep python | grep -v grep | wc -l`
    echo -e "python process num:\t" $current_app_num >> $LOG_FILE
    
    # CPU使用百分比
    current_cpu_idle=`top -b -n 2 -d 0.01 | awk '/^top/{i++}i==2' | head -n 30 |grep Cpu | awk -F ',' '{print $4}' | awk '{print $1}'`
    current_cpu_used_per=$(echo 100-$current_cpu_idle | bc)
    echo -e "cpu used percent:\t" $current_cpu_used_per% >> $LOG_FILE
    
    # 1min的load_average
    current_1min_load_average=`top -b -n 2 -d 0.01 | awk '/^top/{i++}i==2' | head -n 30 |grep "load average" | awk -F ',' '{print $4}' | awk '{print $3}'`
    echo -e "1 minutes load average:\t" $current_1min_load_average >> $LOG_FILE
    
    # 内存使用比例
    total_mem=`free -m | sed -n '2p' | awk '{print $2}'`
    current_used_mem=`free -m | sed -n '2p' | awk '{print $3}'`
    current_mem_used_per=$(echo 100*$current_used_mem/$total_mem | bc)
    echo -e "memory used percent:\t" $current_mem_used_per% >> $LOG_FILE
    
    # swap使用比例
    total_swap=`free -m | sed -n '3p' | awk '{print $2}'`
    current_used_swap=`free -m | sed -n '3p' | awk '{print $3}'`
    current_swap_used_per=$(echo 100*$current_used_swap/$total_swap | bc)
    echo -e "swap used percent:\t" $current_swap_used_per% >> $LOG_FILE
    
    echo -e "\n" >> $LOG_FILE
    
    # 将当前值域阈值比较，如果超过阈值，则发告警
    msg=""
    if [ $current_app_num -gt $max_app_num ]
    then
        msg=$msg"\tpython process num: "$current_app_num"\n"
    fi
    
    if [ `echo "$current_cpu_used_per > $max_cpu_used_per" | bc` -eq 1 ]
    then
        msg=$msg"\tcpu used percent: "$current_cpu_used_per"%\n"
    fi
	
	if [ `echo "$current_1min_load_average > $max_load_average" | bc` -eq 1 ]
    then
        msg=$msg"\t1 minutes load average: "$current_1min_load_average"\n"
    fi
	
	if [ `echo "$current_mem_used_per > $max_mem_used_per" | bc` -eq 1 ]
    then
        msg=$msg"\tmemory used percent: "$current_mem_used_per"%\n"
    fi
	
	if [ `echo "$current_swap_used_per > $max_swap_used_per" | bc` -eq 1 ]
    then
        msg=$msg"\tswap used percent: "$current_swap_used_per"%\n"
    fi
    
	# 拼装消息，发送告警
    if [ "$msg" ]
    then
	    msg=$current_time"\n"$server_name" warning:\n"$msg
    	echo -e $msg >> $LOG_FILE
		
	    current_sys_time=$(date -d "$current_time" +%s)
		diff_time=$(echo $current_sys_time-$last_alarm_time | bc)
		if [ $diff_time -gt $min_alarm_time_interval ]
	    then
            post_alarm $msg
			last_alarm_time=$current_sys_time;
        fi
    fi
}

# 每间隔一段时间检查一次服务器情况
while [ 1 ]
do
    # 检查服务器情况
    observe_server
	# 只保留三天的日志
	ls -t | grep log | sed -n '4,$p' | xargs -I {} rm -rf {}
	sleep 30
done