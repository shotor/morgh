# 🐪🐔 shotor/morgh dotfiles

## Dependencies

- [Linux](https://en.wikipedia.org/wiki/Linux)
- [Stow](https://www.gnu.org/software/stow/)

## Usage

Run commands from the `dotfiles` directory.

For Qubes, the checkout is `/srv/shotor/morgh`. Salt and the dev-session login
hook run Stow automatically; see [the Qubes setup](../qubes/README.md).
The dev profile uses `git vim urxvt nvim tmux zsh starship firefox`. Dom0 uses `git vim` here plus
the Qubes-specific `i3` and `x11` packages under `qubes/salt/dom0/files`.

Theme files link to the checked-in outputs in `../theme/.build/`. Include
`theme` when using a sparse checkout. See [theme setup](../theme/README.md).

### Install on a new machine

Stow a package into your home directory:

```sh
stow docker
```

Stow multiple packages:

```sh
stow docker git zsh
```

### Adopt existing file

Move existing files into a package and replace them with symlinks:

```sh
stow --adopt docker
```

### Remove

Remove a package's symlinks:

```sh
stow --delete docker
```

The files in the dotfiles repository are left untouched.

### Restow

Recreate a package's symlinks after changing the file structure within the `dotfiles` directory:

```sh
stow --restow docker
```

## License

[MIT](https://github.com/shotor/morgh/blob/main/LICENSE)
