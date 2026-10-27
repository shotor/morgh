include:
  - shotor.codex

morgh-dotfile-packages:
  pkg.installed:
    - pkgs:
      - git
      - stow

/srv/shotor:
  file.directory:
    - user: user
    - group: work
    - mode: '2770'
    - makedirs: true
    - require:
      - group: work

morgh-default-permissions:
  cmd.run:
    - name: setfacl -m d:u::rwx,d:g::rwx,d:m::rwx,d:o::--- /srv/shotor
    - unless: getfacl -cp /srv/shotor | grep -Fxq 'default:group::rwx'
    - require:
      - file: /srv/shotor
      - pkg: codex-packages

/etc/qubes-bind-dirs.d/60-morgh.conf:
  file.managed:
    - contents: "binds+=( '/srv/shotor' )\n"
    - makedirs: true
    - mode: '0644'
    - require:
      - cmd: morgh-default-permissions

morgh-template-clone:
  cmd.run:
    - name: >-
        git -c http.proxy=http://127.0.0.1:8082 clone
        --depth=1 --single-branch --no-tags --filter=blob:none --sparse
        https://github.com/shotor/morgh.git /srv/shotor/morgh
    - runas: user
    - creates: /srv/shotor/morgh/.git
    - require:
      - pkg: morgh-dotfile-packages
      - cmd: morgh-default-permissions

morgh-template-sparse-checkout:
  cmd.run:
    - name: >-
        git -c http.proxy=http://127.0.0.1:8082 -C /srv/shotor/morgh
        sparse-checkout set --cone dotfiles qubes theme
    - runas: user
    - unless: test "$(git -C /srv/shotor/morgh sparse-checkout list 2>/dev/null)" = "$(printf 'dotfiles\nqubes\ntheme')"
    - require:
      - cmd: morgh-template-clone

/usr/bin/morgh-update:
  file.managed:
    - source: salt://shotor/morgh/files/morgh-update
    - mode: '0755'

morgh-template-update:
  cmd.run:
    - name: /usr/bin/morgh-update
    - cwd: /srv/shotor/morgh
    - runas: user
    - stateful: true
    - require:
      - cmd: morgh-template-sparse-checkout
      - file: /usr/bin/morgh-update

/usr/bin/morgh-setup:
  file.managed:
    - source: salt://shotor/morgh/files/morgh-setup
    - mode: '0755'

morgh-template-stow:
  cmd.run:
    - name: /usr/bin/morgh-setup dev
    - runas: user
    - require:
      - pkg: morgh-dotfile-packages
      - cmd: morgh-default-permissions
      - file: /usr/bin/morgh-setup
      - cmd: morgh-template-update

/etc/xdg/autostart/morgh-setup.desktop:
  file.managed:
    - mode: '0644'
    - makedirs: true
    - contents: |
        [Desktop Entry]
        Type=Application
        Name=Morgh dotfiles
        Exec=/usr/bin/morgh-setup dev
        Terminal=false
        NoDisplay=true
    - require:
      - cmd: morgh-template-stow
