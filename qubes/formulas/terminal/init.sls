wezterm-repository-tools:
  pkg.installed:
    - pkgs:
      - ca-certificates
      - curl
      - gnupg

wezterm-repository-key:
  cmd.run:
    - name: >-
        curl --fail --location --retry 3
        --proxy http://127.0.0.1:8082 --noproxy ''
        --output /var/cache/wezterm-repository.asc https://apt.fury.io/wez/gpg.key &&
        gpg --batch --yes --dearmor --output /usr/share/keyrings/wezterm-fury.gpg
        /var/cache/wezterm-repository.asc &&
        chmod 0644 /usr/share/keyrings/wezterm-fury.gpg
    - creates: /usr/share/keyrings/wezterm-fury.gpg
    - require:
      - pkg: wezterm-repository-tools

wezterm-repository:
  pkgrepo.managed:
    - name: deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *
    - file: /etc/apt/sources.list.d/wezterm.list
    - require:
      - cmd: wezterm-repository-key

terminal-packages:
  pkg.installed:
    - pkgs:
      - wezterm
      - fonts-dejavu-core
      - fonts-symbola
      - fonts-font-awesome
      - fonts-powerline
      - fontconfig
      - locales
    - require:
      - pkgrepo: wezterm-repository

terminal-locale:
  locale.present:
    - name: en_US.UTF-8
    - require:
      - pkg: terminal-packages

{% for mode in ['light', 'dark'] %}
/etc/wezterm/colors/shotormorgh-{{ mode }}.toml:
  file.managed:
    - source: salt://shotor/morgh-theme/terminal/wezterm/shotormorgh-{{ mode }}.toml
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
{% endfor %}

/etc/wezterm/wezterm.lua:
  file.managed:
    - source: salt://shotor/morgh-dotfiles/wezterm/.config/wezterm/wezterm.lua
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - require:
      - file: /etc/wezterm/colors/shotormorgh-light.toml
      - file: /etc/wezterm/colors/shotormorgh-dark.toml

/usr/bin/wezterm-terminal:
  file.managed:
    - source: salt://shotor/terminal/files/wezterm-terminal
    - mode: '0755'
    - require:
      - pkg: terminal-packages
      - file: /etc/wezterm/wezterm.lua

wezterm-terminal-alternative:
  alternatives.install:
    - name: x-terminal-emulator
    - link: /usr/bin/x-terminal-emulator
    - path: /usr/bin/wezterm-terminal
    - priority: 60
    - require:
      - file: /usr/bin/wezterm-terminal

default-terminal:
  alternatives.set:
    - name: x-terminal-emulator
    - path: /usr/bin/wezterm-terminal
    - require:
      - alternatives: wezterm-terminal-alternative
