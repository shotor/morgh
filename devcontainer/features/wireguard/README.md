
# WireGuard (wireguard)

Installs WireGuard and networking tools.

## Example Usage

```json
"features": {
    "ghcr.io/shotor/devcontainer/features/wireguard:0": {}
}
```



## Container permissions

Add the following to `.devcontainer/devcontainer.json`:

```json
{
  "runArgs": ["--cap-add=NET_ADMIN", "--device=/dev/net/tun"]
}
```

`NET_ADMIN` allows the container to create and configure network interfaces and routes.

`/dev/net/tun` provides access to the TUN device used by WireGuard.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
