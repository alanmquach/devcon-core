FROM ubuntu:xenial

MAINTAINER Alan Quach <integsrtite@gmail.com>

ENV TZ=America/Los_Angeles

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
    && echo $TZ > /etc/timezone && rm -rf /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_US.UTF-8 \
    && mkdir /var/run/sshd

CMD ["/usr/sbin/sshd", "-D"]

