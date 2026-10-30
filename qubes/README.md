# 🐪🐔 shotor/morgh qubes

## Deploy (dom0)

Configure the private FIDO pillar below before the first highstate.
Push dotfile changes to GitHub before deployment. Dev template highstate clones
or updates the checkout through the Qubes update proxy, then runs Stow.
Updates use fast-forward only and do not reset local changes. Existing AppVMs
keep their independent persistent checkouts.

```sh
cpfrom dev-qubes /srv/shotor/morgh /srv/shotor/morgh
cd /srv/shotor/morgh/qubes
./init.sh
```

Dom0:

```sh
./apply.sh dom0
```

One or more templates:

```sh
./apply.sh tpl-deb-13-dev
./apply.sh tpl-deb-13-net tpl-deb-13-vault-net
./apply.sh --template
```

For subsequent copies, run `./sync.sh` in dom0. Restart the affected AppVMs
after applying template changes.

Dev and dvm use stable Firefox from Mozilla's APT repository. Salt updates Firefox
and downloads the default extensions through the Qubes update proxy. Both get
uBlock Origin (including private windows) and Vimium; dev also gets Multi-Account
Containers and Containers New Tab. Check `about:policies` after starting Firefox.
If switching from ESR opens a new profile, select the existing one in `about:profiles`.

Dom0 uses urxvt with the dark theme and Bash. Run `tmux` for the simplified,
plugin-free tmux setup. WezTerm dotfiles remain available for other machines,
but the template packages are removed.

AppVM menus show Firefox, Thunderbird, and KeePassXC where installed, plus Run Terminal.
Dom0 highstate sets the template defaults and existing AppVM
selections. After installing new applications, run `qvm-sync-appmenus TEMPLATE`
and `morgh-appmenus` in dom0 to refresh the selections. Nextcloud continues
syncing independently of its menu entry.

## Mail template (dom0)

Clone a clean Debian 13 template, not the dev template (replace `debian-13-minimal`
if your clean base has a different name):

```sh
qvm-clone debian-13-minimal tpl-deb-13-mail
./sync.sh
./init.sh
./apply.sh tpl-deb-13-mail
qvm-sync-appmenus tpl-deb-13-mail
./apply.sh dom0
```

Mail uses Thunderbird's latest stable release from Mozilla's `thunderbird-deb`
APT repository, shared urxvt/themes, Zsh, Oh My Zsh, Starship, tmux, lsd, zoxide,
and htop. Salt clones morgh into `/srv/shotor/morgh` and runs `morgh-setup mail`
to Stow urxvt, Zsh, Starship, and the full tmux config with tpack. Existing mail
AppVM checkouts remain independent and persistent. It does not
include the dev, FIDO, or KeePassXC formulas. Updates also work through the
normal Qubes updater.

## Display (dom0)

After applying dom0, register the connected monitor once:

```sh
morgh-display-setup DP-4
```

Autorandr uses that monitor alone at its highest advertised resolution and refresh
rate, and returns to the laptop panel when disconnected. EDID profiles stay in
`~/.config/autorandr` on dom0. Rerun setup to replace the saved monitor.

On the registered 5120×1440 monitor, new workspaces start with a centered
2560-wide window. The next two windows fill the right, then left quarter.
After that, focus a column and use normal i3 splits (`Super+h` / `Super+v`).
Existing window arrangements are left alone when the helper first starts.
The registered monitor uses 16-pixel inner gaps; the laptop uses none.
Automatic layout dimensions account for i3 DPI scaling.

`Super+g` selects presets and adjusts empty space while keeping windows tiled:

- `c`: centered preset for a single window (or an empty workspace).
- `r`: right-aligned preset on an empty workspace or a flat row. Windows start
  at 1920 pixels wide; new windows appear on the left, shrinking to fit when full.
- Left/Right: narrow/widen the occupied area. The right preset changes only the
  left margin; other modes change both margins.
- Down/Up: shorten/heighten the area; `0`: reset to normal tiling.
- Enter/Escape: finish.

Resize shared borders normally with the mouse or `Super+r`. Explicit splits,
tabs and stacks take precedence over automatic right-preset insertion.
Presets are per workspace. The bar shows the preset and focused container layout,
for example `right · tabbed` or `centered · split v`.

After syncing helper changes, restart just the helper and refresh i3/bar:

```sh
i3-msg 'exec --no-startup-id ~/.local/bin/morgh-i3-layout restart'
i3-msg restart
```

## Codex networking

`codexjail` starts a dedicated network namespace in the same AppVM. Project
folders remain shared. A root-managed nftables table allows IPv4 internet
traffic through `eth0`, blocks private/reserved destinations (including
Tailscale's IPv4 range), and blocks IPv6 and access to AppVM-local services.
DNS uses Quad9 (9.9.9.9 and 149.112.112.112) instead of the AppVM's internal resolver.
The namespace uses 192.0.2.0/30 for its virtual link.

Apply `tpl-deb-13-dev`, restart the AppVM, and launch `codexjail` normally.
Existing jail sessions must be closed; they retain their old network access.
The namespace is created on first launch, not in the template during Salt.
The network helper is installed under `/usr/libexec/morgh`, since AppVMs keep
their own `/usr/local` and do not inherit template updates there.

Additional VPN destinations using public IPv4 space must be listed as CIDRs,
one per line, in `/rw/config/codexjail/blocked-v4` inside the AppVM. Keep this
file and its parent root-owned and unwritable by `agent`. The file is private
and persists across AppVM restarts. Invalid entries prevent new jail launches.
To apply changes to running sessions:

```sh
sudo /usr/libexec/morgh/codexjail-network refresh
```

Inspect the host-side rules and test from the namespace:

```sh
sudo nft list table inet codexjail
sudo ip netns exec codexjail curl -4 -I --max-time 10 https://example.com
sudo ip netns exec codexjail curl -4 -I --max-time 3 http://172.18.1.1
```

To allow all container ports on selected local Docker bridge networks, put
their Docker network names (one per line) in the private AppVM file
`/rw/config/codexjail/docker-networks`. Keep the file and parent root-owned and
unwritable by `agent`. After starting Docker and creating the networks, run:

```sh
sudo /usr/libexec/morgh/codexjail-network refresh
```

Codex can then use the containers' actual IPv4 addresses. Each exception matches
both the Docker subnet and bridge interface; other private destinations and
AppVM-local services remain blocked. Selected Docker networks override the
destination blocklist only on their bridges. Container names are not added to
DNS. No Docker socket is exposed to the jail.

This integration supports Docker's standard iptables backend with a
`DOCKER-USER` chain, not its native nftables backend or rootless networking.
Refresh after recreating networks or restarting Docker. Missing or unsupported
networks prevent a new jail launch and revoke existing Docker exceptions.
Services on an allowed network are trusted destinations: a proxy service there
could provide indirect access to other networks.

The internet request should succeed; the private-address request should time
out. Internet traffic still follows the AppVM's upstream gateway, including
any VPN exit node. This is direct-network isolation, not protection against
public relays or modified shared scripts that you later execute outside the
jail. Stopping `codexjail-network.service` disconnects running jail sessions.

## KeePassXC

Keep client-to-vault mappings in a private dom0 pillar:

```sh
sudo install -d -m 0700 /srv/pillar/base/services
sudoedit /srv/pillar/base/services/init.sls /srv/pillar/base/services/init.top
```

`init.sls` (replace the example VM names):

```yaml
keepassxc:
  clients:
    CLIENT_VM: VAULT_VM
```

`init.top`:

```yaml
base:
  dom0:
    - services
```

```sh
sudo chmod 0600 /srv/pillar/base/services/init.{sls,top}
sudo qubesctl top.enable services pillar=True
./sync.sh
./init.sh
./apply.sh tpl-deb-13-dev tpl-deb-13-dvm tpl-deb-13-vault-net dom0
```

Restart the affected AppVMs. In the networked vault, open KeePassXC, unlock the
database and enable Firefox under Settings → Browser Integration. In each
allowed client, connect KeePassXC-Browser and approve pairing in the vault.
The vault must be running; an empty client mapping denies access. The offline
vault template does not install the remote service.

## Network templates

`tpl-deb-13-net` supplies networking and WireGuard packages for network, firewall,
and WireGuard VMs. `tpl-deb-13-ts` supplies networking and Tailscale packages.
Create the templates separately before targeting them with highstate.

Enable services only on the corresponding gateways (dom0), then restart them:

```sh
qvm-service TS_VM tailscale on
qvm-service TS_VM vpn-dns on
qvm-service WG_VM vpn-dns on
```

WireGuard configuration in `/etc/wireguard` and Tailscale state in
`/var/lib/tailscale` persist separately in each AppVM. Configure credentials in
the AppVM, not the template.

Authenticate inside the Tailscale gateway:

```sh
sudo tailscale up --login-server=https://HEADSCALE_SERVER --accept-dns=true
```

Headscale supplies the recursive DNS servers for all domains. Enable
`--accept-routes=true` if you also need Headscale's advertised subnet routes.

Put each WireGuard config in `/etc/wireguard/NAME.conf`, owned by root with mode
`0600`. Its `DNS=` entries must include the DNS server addresses and internal
domain suffixes. WireGuard tunnels start manually; Tailscale reconnects at boot
after authentication. Keep IPv4 and IPv6 configs as separate files with distinct
names of at most 15 characters. Simultaneous tunnels must have compatible routes.

Start or stop a tunnel inside the gateway:

```sh
sudo systemctl start wg-quick@NAME
sudo systemctl stop wg-quick@NAME
resolvectl status
```

The service uses `wg-vpn` to register only the configured DNS domains with
resolved. For manual operation use `sudo wg-vpn up NAME` / `down NAME`, not
plain `wg-quick`. Omit `SaveConfig=true` so shutdown cannot discard the domain
mappings. Other queries use the gateway's normal upstream DNS.

Connect AppVMs to the gateway and enable IPv6 there if needed (dom0):

```sh
qvm-prefs APP_VM netvm VPN_VM
qvm-features VPN_VM ipv6 1
```

Restart the gateway and connected AppVMs after enabling IPv6. Multiple
WireGuard tunnels can share one gateway. To also use the separate Tailscale
gateway, set the WireGuard gateway's NetVM to the Tailscale gateway.
These states configure DNS and tunnel startup; they do not install a VPN
kill switch or select an exit node.

## FIDO clients (dom0)

```sh
sudo install -d -m 0700 /srv/pillar/base/fido
sudoedit /srv/pillar/base/fido/init.sls /srv/pillar/base/fido/init.top
```

`init.sls`:

```yaml
fido:
  clients:
    - CLIENT_VM
```

`init.top`:

```yaml
base:
  dom0:
    - fido
  tpl-deb-13-ssh:
    - fido
  CLIENT_TEMPLATE:
    - fido
```

Enable and apply (the client template must include `shotor.ssh-agent.client`):

```sh
sudo chmod 0600 /srv/pillar/base/fido/init.{sls,top}
sudo qubesctl top.enable fido pillar=True
sudo qubesctl state.highstate
sudo qubesctl --skip-dom0 --show-output --targets=tpl-deb-13-ssh,CLIENT_TEMPLATE state.highstate
```

Shut down those templates and restart `sys-fido` and the client VM.
Attach the YubiKey using its identifier from `qvm-usb list`:

```sh
qvm-usb list
qvm-usb assign --device sys-fido sys-usb:USB_PORT
qvm-usb attach sys-fido sys-usb:USB_PORT
```

## Browser security keys

In dom0, add `browser_clients` under the existing `fido` mapping in
`/srv/pillar/base/fido/init.sls`, keeping `clients` unchanged:

```yaml
fido:
  clients:
    - SSH_CLIENT_VM
  browser_clients:
    - BROWSER_VM
```

Browser access is independent of SSH key assignments. Listed VMs can use CTAP
credentials on the YubiKey; this list does not restrict individual credentials.
An absent or empty `browser_clients` list denies browser access.

From dom0, after copying the checkout:

```sh
cd /srv/shotor/morgh/qubes
./init.sh
sudo qubesctl --skip-dom0 --show-output --targets=tpl-deb-13-ssh,tpl-deb-13-dev state.highstate
sudo qubesctl state.highstate
qvm-service BROWSER_VM qubes-ctap-proxy on
```

Shut down both templates, then restart `sys-fido` and the browser VM. Keep the
YubiKey attached to `sys-fido`. Run `fido-load` again for SSH after restarting it.
The browser client uses `qubes-ctapproxy@sys-fido.service`; other browser
templates must include `shotor.ctap.client`. No browser extension is required.

The formula requires `qubes-ctap` 2.0.8 or newer, which includes the
[QSB-120 fixes](https://www.qubes-os.org/news/2026/10/08/qsb-120/).

## FIDO key assignments (sys-fido)

Store public keys under `~/.ssh/fido/nfc`, `primary`, and `backup` on sys-fido.
Put one permitted public-key path per line in `~/.config/fido/CLIENT_VM`, relative
to `~/.ssh/fido`. These assignments stay private in sys-fido.

```sh
mkdir -p ~/.config/fido
chmod 700 ~/.config/fido
printf '%s\n' 'primary/KEY_HANDLE_FILENAME.pub' 'backup/KEY_HANDLE_FILENAME.pub' > ~/.config/fido/CLIENT_VM
chmod 600 ~/.config/fido/CLIENT_VM
fido-load CLIENT_VM
```

Attach the YubiKeys you want to use, then run `fido-load`. It enumerates all
attached FIDO authenticators and retrieves resident handles from each device,
with a separate PIN prompt for each. It clears the client's agent first and
loads only keys whose SHA256 public-key fingerprints are permitted. Identical
filenames on different devices do not collide, and duplicate fingerprints are
loaded once. The list is
an allowlist of alternatives: other devices' keys need not be present, but at
least one permitted key must match across the attached devices. Failure on any
device leaves the client's agent empty. Temporary handles are always removed.
An empty list explicitly clears the agent.

Existing bare handle filenames (with or without `.pub`) resolve to saved public
keys in `~/.ssh/fido` and its immediate subdirectories. Explicit paths restrict
permission to particular inventories. Every reference must resolve to a saved
public key; filenames alone never authorize an attached key.

Repeat `fido-load CLIENT_VM` after restarting sys-fido or swapping YubiKeys.
No saved private handle files are needed. SSH services must separately authorize
each device's public key.

In the client VM, check the available keys:

```sh
ssh-add -l
ssh -T git@github.com
```

