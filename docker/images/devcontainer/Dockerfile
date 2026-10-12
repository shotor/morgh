FROM node:26-alpine

RUN apk add --no-cache \
    docker \
    docker-cli-buildx \
    su-exec

RUN npm install -g @devcontainers/cli

WORKDIR /workspace
