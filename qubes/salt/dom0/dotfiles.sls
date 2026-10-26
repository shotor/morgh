{% set user = salt['pillar.get']('morgh:dom0_user', 'shotor') %}

dom0-dotfile-packages:
  pkg.installed:
    - pkgs:
      - feh
      - git
      - stow

dom0-stow:
  cmd.run:
    - name: bash /srv/shotor/morgh/qubes/formulas/morgh/files/morgh-setup dom0
    - runas: {{ user }}
    - require:
      - pkg: dom0-dotfile-packages
