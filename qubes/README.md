# 🐪🐔 shotor/morgh qubes

## Deploy (dom0)

Configure the private FIDO pillar below before the first highstate.
Push dotfile changes to GitHub before deployment. Dev template highstate clones
or updates the checkout through the Qubes update proxy, then runs Stow.
Updates use fast-forward only and do not reset local changes. Existing AppVMs
keep their independent persistent checkouts.

```sh
cpfrom dev-qubes /srv/git/morgh /srv/shotor/morgh
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
```

For subsequent copies, run `./sync.sh` in dom0. Restart the affected AppVMs
after applying template changes.

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

For existing resident SSH keys, use the original handle filename produced by
`ssh-keygen -K`, without `.pub`. Put one filename per line in the client's file.

```sh
mkdir -p ~/.config/fido
chmod 700 ~/.config/fido
printf '%s\n' 'KEY_HANDLE_FILENAME' > ~/.config/fido/CLIENT_VM
chmod 600 ~/.config/fido/CLIENT_VM
fido-load CLIENT_VM
```

Enter the YubiKey PIN when prompted. Repeat `fido-load CLIENT_VM` after restarting
`sys-fido`. Handles are retrieved temporarily; no saved private handle files are needed.

In the client VM, check the available keys:

```sh
ssh-add -l
ssh -T git@github.com
```

