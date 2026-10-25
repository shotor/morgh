# Qubes

## Deploy (dom0)

Configure the private FIDO pillar below before the first highstate.
Push dotfile changes to GitHub before the dev template clones or pulls them.

```sh
cpfrom dev-qubes /srv/git/morgh /srv/shotor/morgh
cd /srv/shotor/morgh/qubes
./init.sh
```

Dom0:

```sh
sudo qubesctl state.highstate
```

One template (replace the name as needed):

```sh
sudo qubesctl --skip-dom0 --show-output --targets=tpl-deb-13-dev state.highstate
```

Shut down the updated template and restart its AppVMs afterward.

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

