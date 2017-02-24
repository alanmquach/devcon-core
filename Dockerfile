FROM ubuntu:trusty

MAINTAINER Alan Quach <integsrtite@gmail.com>

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN locale-gen en_US.UTF-8

# CORE
RUN apt-get update && apt-get install -y openssh-server \
    ca-certificates \
    curl \
    zip unzip tar \
    dnsutils \
    man \
    build-essential \
    cmake python-dev python3-dev \
    tmux \
    git \
    vim \
    silversearcher-ag \
    mosh \
    python-pip \
    python3-pip
RUN mkdir /var/run/sshd

EXPOSE 22
EXPOSE 60000-60010

CMD ["/usr/sbin/sshd", "-D"]

