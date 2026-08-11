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
