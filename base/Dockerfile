FROM ubuntu:20.04

RUN apt-get update -y && apt-get install -y ca-certificates curl wget vim gnupg2 iputils-ping unzip jq
RUN apt-get install -y apt-transport-https openssh-server sudo software-properties-common
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y tzdata git
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt-get update -y && apt-get install -y docker-ce
RUN curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose