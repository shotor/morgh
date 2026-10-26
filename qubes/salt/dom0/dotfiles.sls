{% set user = salt['pillar.get']('morgh:dom0_user', 'shotor') %}

dom0-dotfile-packages:
  pkg.installed:
    - pkgs:
      - bash
      - brightnessctl
      - feh
      - git
      - stow

dom0-user-shell:
  cmd.run:
    - name: usermod --shell /bin/bash -- {{ user | quote }}
    - unless: test "$(getent passwd {{ user | quote }} | cut -d ':' -f 7)" = /bin/bash
    - require:
      - pkg: dom0-dotfile-packages

dom0-stow:
  cmd.run:
    - name: bash /srv/shotor/morgh/qubes/formulas/morgh/files/morgh-setup dom0
    - runas: {{ user }}
    - require:
      - pkg: dom0-dotfile-packages
