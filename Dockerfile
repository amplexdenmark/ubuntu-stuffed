 ##
 # (C) Copyright 2018 Amplex, fm@amplex.dk
 ##
FROM ubuntu:16.04

MAINTAINER Flemming Madsen <amplexdenmark@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get --no-install-recommends install -y \
    curl sudo htop aptitude man multitail less vim-tiny nano net-tools cron patch unzip nodejs openssh-server locales && \
    locale-gen en_US.UTF-8 && \
    apt-get dist-upgrade -y && \
    apt-get -y autoremove && \
    apt-get -y autoclean

# From https://docs.docker.com/engine/examples/running_ssh_service/
# SSH login fix (/etc/pam.d/sshd). Otherwise user is kicked off after login
ENV NOTVISIBLE "in users profile"
RUN mkdir /var/run/sshd && \
    sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

ENTRYPOINT ["/bin/bash"]

