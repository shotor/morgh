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

COPY docker-init.sh /sbin/docker-init
RUN chmod +x /sbin/docker-init

WORKDIR /workspace
