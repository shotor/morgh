include:
  - shotor.dev-shell
  - shotor.thunderbird
  - shotor.tpack
  - shotor.morgh

mail-packages:
  pkg.installed:
    - pkgs:
      - lsd
      - zoxide
      - htop
      - tmux
      - xsel
      - qubes-core-agent-passwordless-root
      - qubes-core-agent-networking

mail-old-zsh-init:
  file.replace:
    - name: /etc/zsh/zshrc
    - pattern: '(?m)^export STARSHIP_CONFIG="\$\{STARSHIP_CONFIG:-/etc/starship\.toml\}"\nsource /etc/morgh/zshrc\n?'
    - repl: ''
    - ignore_if_missing: true
    - require:
      - pkg: dev-shell-packages

/etc/morgh/zshrc:
  file.absent:
    - require:
      - file: mail-old-zsh-init

/etc/starship.toml:
  file.absent: []

/etc/tmux.conf:
  file.absent:
    - onlyif: grep -Fxq "bind r source-file /etc/tmux.conf" /etc/tmux.conf && grep -Fxq "run-shell 'morgh-theme tmux'" /etc/tmux.conf
