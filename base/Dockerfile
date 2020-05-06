FROM ubuntu:18.04

RUN apt-get update -y && apt-get install -y ca-certificates curl wget vim gnupg2 iputils-ping unzip jq
RUN apt-get update -y && apt-get install -y apt-transport-https sudo openssh-server git software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt-get update -y && apt-get install -y docker-ce
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose