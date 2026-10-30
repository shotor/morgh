{% set user = salt['pillar.get']('morgh:dom0_user', 'shotor') %}

dom0-dotfile-packages:
  pkg.installed:
    - pkgs:
      - bash
      - brightnessctl
      - python3-i3ipc
      - feh
      - git
      - stow
      - rxvt-unicode
      - rofi
      - tmux
      - xsel
      - zoxide
      - dejavu-sans-mono-fonts

/usr/local/bin/urxvt-terminal:
  file.managed:
    - source: salt://shotor/dom0/files/urxvt-terminal
    - mode: '0755'
    - makedirs: true
    - require:
      - pkg: dom0-dotfile-packages

/etc/profile.d/morgh-terminal.sh:
  file.managed:
    - contents: 'export TERMINAL=/usr/local/bin/urxvt-terminal'
    - mode: '0644'

dom0-user-shell:
  cmd.run:
    - name: usermod --shell /bin/bash -- {{ user | quote }}
    - unless: test "$(getent passwd {{ user | quote }} | cut -d ':' -f 7)" = /bin/bash
    - require:
      - pkg: dom0-dotfile-packages

/home/{{ user }}/.bashrc:
  file.append:
    - text:
      - 'eval "$(zoxide init bash)"'
      - 'PS1=''\u@\h:\w\n\$ '''
    - require:
      - pkg: dom0-dotfile-packages

dom0-stow:
  cmd.run:
    - name: bash /srv/shotor/morgh/qubes/formulas/morgh/files/morgh-setup dom0
    - runas: {{ user }}
    - require:
      - pkg: dom0-dotfile-packages
