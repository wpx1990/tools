#设置继承镜像
FROM ubuntu:20.04

RUN apt-get update

#安装ssh服务
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh

#取消pam限制
RUN sed -ri  's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g'  /etc/pam.d/sshd
#配置root可以ssh登录
RUN sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
#设置root密码
RUN echo root:admin_123 | chpasswd

#设置自启动命令
WORKDIR /root
USER root
COPY run.sh /root/run.sh
RUN chmod 755 /root/run.sh
ENTRYPOINT ["/root/run.sh"]