# 🐪🐔 shotor/morgh dotfiles

## Dependencies

- [Linux](https://en.wikipedia.org/wiki/Linux)
- [Stow](https://www.gnu.org/software/stow/)

## Usage

Run commands from the `dotfiles` directory.

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
