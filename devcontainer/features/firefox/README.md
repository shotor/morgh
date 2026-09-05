
# Firefox (firefox)

Installs Firefox stable from Mozilla's APT repository and its runtime dependencies.

## Example Usage

```json
"features": {
    "ghcr.io/shotor/devcontainer/features/firefox:0": {}
}
```



## Installation

Installs the current Firefox stable DEB package using
[Mozilla's official APT repository](https://support.mozilla.org/en-US/kb/install-firefox-linux).
APT installs the browser's runtime dependencies. Supports Debian/Ubuntu images
on architectures for which Mozilla publishes the Firefox DEB package.

The repository signing key fingerprint is checked before use. Firefox packages
prefer Mozilla's repository; Ubuntu's transitional Firefox package is excluded.
The repository remains configured for subsequent APT updates. The browser version
is resolved at build time, not pinned by the Feature version.

## Use with Xpra

Add both Features to your Dev Container configuration:

```json
"features": {
    "ghcr.io/shotor/devcontainer/features/firefox:0": {},
    "ghcr.io/shotor/devcontainer/features/xpra:0": {}
}
```

The Xpra Feature owns the display server and starts it on `:100`. This Feature
only installs Firefox; it does not start a browser or set a global display.

Inside the container, launch Firefox on that display:

```bash
DISPLAY=:100 MOZ_ENABLE_WAYLAND=0 firefox
```

On the host, attach with the Xpra client:

```bash
xpra attach ssh://devcontainer/100
```

Replace `devcontainer` with your container's SSH alias. For extension development,
use web-ext with `--firefox /usr/bin/firefox` and the same display environment.
Projects requiring a minimum Firefox version should check `firefox --version`.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
