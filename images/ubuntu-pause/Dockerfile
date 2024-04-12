#设置继承镜像
FROM ubuntu:20.04

RUN mkdir -p /root
COPY pause.sh /root/pause.sh
RUN chmod 755 /root/pause.sh
ENTRYPOINT ["/root/pause.sh"]