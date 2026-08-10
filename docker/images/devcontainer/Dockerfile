FROM node:24-alpine

RUN apk add \
  --no-cache \
  docker-cli \
  docker-cli-buildx

RUN npm install -g @devcontainers/cli

WORKDIR /workspace

ENTRYPOINT ["devcontainer"]
