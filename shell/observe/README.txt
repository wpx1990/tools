监测服务器的负载情况，给钉钉机器人发告警

启动方法：
chmod +x /home/wpx/observe/observe.sh
nohup /home/wpx/observe/observe.sh >/dev/null 2>&1 &

说明：
30秒检查一次，数据记录在/home/wpx/observe，数据保留最近3天的。 若下面的指标超过阈值就发报警。发完一次报警后，未来一个小时后不会再发。

# 以下异常指标，则发告警
max_app_num=20 # app数量大于20
max_cpu_used_per=90 # 使用CPU大于90%，
max_load_average=10 # 1min的load_average大于10
max_mem_used_per=90 # 最大内存使用比例
max_swap_used_per=90 # 最大swap使用比例