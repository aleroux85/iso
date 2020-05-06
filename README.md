# Iso

A technique to allow one to run development environments inside containers and
keep the original installation as clean as posible. After a fresh installation,
simply install Docker, your ssh key, an editor (optional) and restore your
project files. Doing a `docker-compose up` on this repositry will start a
container where you can ssh into.

All dev environment configurations stay in the container and are reproducible.
Configure multiple environments and specify the files to be mounted and ports
that must be exported and ssh into the container to run or compile code. Code
outside the container or inside with ssh supporting editors. 

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- ssh (with keys)

## Setup

1) Copy your public-key into this repo with:

```bash
cp ~/.ssh/id_rsa.pub id_rsa.pub
```

2) Create a `docker-compose.override.yml` file with:

```none
version: "3.7"
services:
  main:
    build:
      args:
        - USER=<user>
        - GROUP=<group>
        - FULL_NAME="<fullname>"
        - EMAIL="<email>"
    # volumes:
      # - /home/<user>/Projects:/home/<user>/Projects
```

and fill in user details and the volumes to mount. Run `id` on your local host
to get your username, groupname, UID and GID. If the UID and GID is not both
1000, set that also in the args above.


3) Add a domain name `main` to your `/etc/hosts` file that point to `127.0.0.1`.

4) Add an agent forwarder rule to your `~/.ssh/config` file.

```ssh
Host main
  ForwardAgent yes
  Port 8022
  User <username>
```

## Using the container

Start the container with:

```bash
docker-compose build
docker-compose up -d
```

Log into the container with:

```bash
ssh main
```

## Building base image

```bash
cat ~/<your-github-key> | docker login docker.pkg.github.com -u <your-github-user> --password-stdin
docker build -f base/Dockerfile -t docker.pkg.github.com/<your-github-user>/iso/base:0.1 .
docker push docker.pkg.github.com/<your-github-user>/iso/base:0.1
```
