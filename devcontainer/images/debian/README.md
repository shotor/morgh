# Debian

## Summary

_A Debian-based development container with a configured development user, Zsh, Starship, and common command-line tools._

| Metadata                    | Value                                       |
| --------------------------- | ------------------------------------------- |
| _Categories_                | Core                                        |
| _Image type_                | Dockerfile                                  |
| _Published image_           | `ghcr.io/shotor/devcontainer/images/debian` |
| _Container host OS support_ | Linux, macOS, Windows                       |
| _Container OS_              | Debian                                      |
| _Default user_              | `user`                                      |

## Using this image

You can directly reference a pre-built version of this image using the `image` property in `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/shotor/devcontainer/images/debian:latest"
}
```

You can also use the image as the base for your own `Dockerfile`:

```dockerfile
FROM ghcr.io/shotor/devcontainer/images/debian:latest
```

## Adding development tools

Additional development tools can be installed using Dev Container Features.

For example, Node.js can be added using the Node Feature:

```json
{
  "image": "ghcr.io/shotor/devcontainer/images/debian:latest",
  "features": {
    "ghcr.io/shotor/devcontainer/features/node:0": {}
  }
}
```

The Node Feature uses mise to install and manage Node.js.

mise can also be installed independently:

```json
{
  "image": "ghcr.io/shotor/devcontainer/images/debian:latest",
  "features": {
    "ghcr.io/shotor/devcontainer/features/mise:0": {}
  }
}
```

## User

The image provides a non-root development user named `user` with the home directory:

```text
/home/user
```

The default working directory is:

```text
/workspace
```

## License

Licensed under the MIT License. See [LICENSE](https://github.com/shotor/morgh/blob/main/LICENSE).
