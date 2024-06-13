ARG base_image=ubuntu:20.04
FROM $base_image

RUN apt update

RUN apt install -y dnsutils
RUN apt install -y tcpdump
RUN apt install -y net-tools
RUN apt install -y telnet
RUN apt install -y iputils-ping
RUN apt install -y vim
RUN apt install -y lrzsz
RUN apt install -y procps
RUN apt install -y iptables
RUN apt install -y build-essential
RUN apt install -y mlocate && updatedb

#安装ssh服务
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh

#取消pam限制
RUN sed -ri  's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g'  /etc/pam.d/sshd
#配置root可以ssh登录
RUN sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
#配置ssh登录端口
RUN sed -ri 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
#设置root密码
RUN echo root:admin_123 | chpasswd

#设置自启动命令
WORKDIR /root
USER root
COPY run.sh /root/run.sh
RUN chmod 755 /root/run.sh
ENTRYPOINT ["/root/run.sh"]