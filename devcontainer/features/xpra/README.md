
# Xpra (xpra)

Installs Xpra for persistent remote X11 applications.

## Example Usage

```json
"features": {
    "ghcr.io/shotor/devcontainer/features/xpra:0": {}
}
```



## Open an application from the host

Use `xpra control` to start a graphical application inside the Dev Container:

```bash
xpra control ssh://devcontainer/100 start <application>
```

For example:

```bash
xpra control ssh://devcontainer/100 start firefox
```

This starts `firefox` on the Xpra display running inside the Dev Container and opens the application on the host.

The Xpra server is started automatically by the Feature on display `:100`.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
