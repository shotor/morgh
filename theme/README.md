# 🐪🐔 shotor/morgh theme

Run from the repository root.

## Build

```sh
python3 theme/build.py
```

## Preview

```sh
firefox theme/preview.html
```

```sh
python3 theme/preview-qubes.py
firefox theme/qubes-preview.html
```

## Qubes colors

Use `shotormorgh-{red,orange,yellow,green,blue,purple,gray,black}-{light,dark}`.
Generated themes cover urxvt, tmux, Vim/Neovim, VS Code/VSCodium, and Rofi.

Qubes VMs automatically select their label through `morgh.Theme` in dom0.
urxvt, tmux, and Vim/Neovim use `morgh-theme`; dark is the default.
The label is cached for the login session, with an uncolored fallback if lookup fails.

Check the selection or refresh it after changing the VM label:

```sh
morgh-theme name
morgh-theme refresh
```

Choose light locally (use `dark` to switch back):

```sh
mkdir -p ~/.config/morgh
printf 'light\n' > ~/.config/morgh/appearance
```

Open a new terminal/editor and reload tmux with `tmux source-file ~/.tmux.conf`.
Refresh Stow links with `morgh-setup dev` after updating the checkout.

Outside Qubes, select blue-dark in the dotfiles:

```sh
ln -sfn shotormorgh-blue-dark.Xresources dotfiles/urxvt/.config/urxvt/config
```

Use `colorscheme shotormorgh-blue-dark` in Vim/Neovim and
`source-file ~/.config/tmux/themes/shotormorgh-blue-dark.conf` in tmux.

Dom0's i3 config uses `.build/desktop/i3/shotormorgh-dark.conf` through
`~/.config/i3/qubes-colors.conf`. The matching light file is also generated.
