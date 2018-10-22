 ##
 # (C) Copyright 2018 Amplex, fm@amplex.dk
 ##
FROM ubuntu:16.04

MAINTAINER Flemming Madsen <amplexdenmark@gmail.com>

# From https://docs.docker.com/engine/examples/running_ssh_service/
# SSH login fix (/etc/pam.d/sshd). Otherwise user is kicked off after login
ENV NOTVISIBLE "in users profile"
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22


RUN apt-get --no-install-recommends install -y \
    curl sudo htop aptitude man multitail less vim-tiny nano net-tools cron patch unzip nodejs openssh-server && \
    apt-get -y autoremove && \
    apt-get -y autoclean


ENTRYPOINT ["/bin/bash"]
