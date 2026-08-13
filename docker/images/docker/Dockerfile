FROM alpine:3.24

RUN apk add --no-cache \
    buildkit \
    containerd \
    curl \
    docker \
    docker-cli-compose \
    git \
    nerdctl \
    wget

RUN mv /usr/bin/docker /usr/bin/docker-real

COPY docker.sh /usr/bin/docker
RUN chmod +x /usr/bin/docker

WORKDIR /workspace
