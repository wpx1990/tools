#设置继承镜像
FROM local-harbor.com/tools/ubuntu:20.04-ssh

RUN apt-get update

RUN apt install -y tcpdump
RUN apt install -y net-tools
RUN apt install -y telnet
RUN apt install -y iputils-ping
RUN apt install -y vim
RUN apt install -y mlocate && updatedb
RUN apt install -y lrzsz