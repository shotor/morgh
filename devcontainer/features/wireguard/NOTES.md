## Container permissions

Add the following to `.devcontainer/devcontainer.json`:

```json
{
  "runArgs": ["--cap-add=NET_ADMIN", "--device=/dev/net/tun"]
}
```

`NET_ADMIN` allows the container to create and configure network interfaces and routes.

`/dev/net/tun` provides access to the TUN device used by WireGuard.
