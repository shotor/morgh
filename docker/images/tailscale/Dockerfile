ARG VERSION=1.102.5

FROM tailscale/tailscale:v${VERSION}

# ethtool: a subnet router in a pod turns the tun's segmentation offload off, the kernel segments forwarded TCP for it
# https://github.com/tailscale/tailscale/issues/16198
RUN apk add --no-cache ethtool

COPY entrypoint.sh /usr/local/bin/entrypoint

ENTRYPOINT ["/usr/local/bin/entrypoint"]
