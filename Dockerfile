# Baseimage for Docker-related Vagrant environments


FROM phusion/baseimage:latest
MAINTAINER Vladislav Stroev <netcemetery@yandex.ru>

# Create vagrant user
RUN adduser --disabled-password --gecos "" vagrant

# Environment variables
ENV HOME /home/vagrant
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Do common baseimage actions
RUN echo "/home/vagrant" > /etc/container_environment/HOME && \
    echo "noninteractive" > /etc/container_environment/DEBIAN_FRONTEND && \
    echo "linux" > /etc/container_environment/TERM && \
    rm -f /etc/service/sshd/down && \
    /usr/sbin/enable_insecure_key && \
    /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install necessary packages
RUN apt-get -qq update && \
    apt-get -qq install -y --no-install-recommends \
        git \
        vim \
        nano \
        curl \
        wget && \
    apt-get clean

# Add Vagrant key
RUN mkdir -p /home/vagrant/.ssh && \
    curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys

# Cleanups
RUN rm -rf /tmp/* /var/tmp/*

# Init process is entrypoint
ENTRYPOINT ["/sbin/my_init", "--"]
