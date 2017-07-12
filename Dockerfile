FROM ubuntu:xenial

MAINTAINER Alan Quach <integsrtite@gmail.com>

# CORE
RUN apt-get update && apt-get install -y \
    tzdata \
    locales \
    openssh-server \
    ca-certificates \
    curl \
    zip unzip tar \
    dnsutils \
    man \
    build-essential \
    cmake python-dev \
    tmux \
    git \
    vim \
    silversearcher-ag \
    mosh \
    python-pip \
    && mkdir /var/run/sshd

CMD ["/usr/sbin/sshd", "-D"]

