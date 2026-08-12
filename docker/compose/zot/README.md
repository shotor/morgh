# zot

## Usage

From this directory

### Docker

```sh
docker compose up
```

### Microsandbox

```sh
msb create \
  ghcr.io/shotor/docker:latest \
  --name zot \
  --replace \
  --net public \
  --port 5000:5000 \
  --mount-dir "$PWD:/workspace:stat-virt=off" \
  -v zot-docker:/var/lib/docker \
  -v zot-data:/var/lib/zot \
  --init /sbin/docker-init
```
