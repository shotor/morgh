# Node

## Summary

_A Node.js development container based on the Shotor Debian image, with Node.js installed and managed using mise._

| Metadata                    | Value                                     |
| --------------------------- | ----------------------------------------- |
| _Categories_                | Languages                                 |
| _Image type_                | Dev Container                             |
| _Published image_           | `ghcr.io/shotor/devcontainer/images/node` |
| _Container host OS support_ | Linux, macOS, Windows                     |
| _Container OS_              | Debian                                    |
| _Default user_              | `user`                                    |

## Using this image

You can directly reference a pre-built version of this image using the `image` property in `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/shotor/devcontainer/images/node:latest"
}
```

You can also use the image as the base for your own `Dockerfile`:

```dockerfile
FROM ghcr.io/shotor/devcontainer/images/node:latest
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

[MIT](https://github.com/shotor/morgh/blob/main/LICENSE).
