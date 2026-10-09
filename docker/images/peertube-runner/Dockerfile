# peertube's remote transcoding runner: the npm package at a pinned version beside debian's ffmpeg, as the node user
FROM node:22-bookworm-slim
# renovate: datasource=npm depName=@peertube/peertube-runner
ARG RUNNER_VERSION=0.7.0
RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && npm install -g "@peertube/peertube-runner@${RUNNER_VERSION}" \
 && npm cache clean --force
COPY entrypoint.sh /entrypoint.sh
# config and registration on the volume, the jobs' scratch in the cache
ENV XDG_CONFIG_HOME=/data/config \
    XDG_DATA_HOME=/data/share \
    XDG_CACHE_HOME=/tmp/cache
USER node
ENTRYPOINT ["/entrypoint.sh"]
