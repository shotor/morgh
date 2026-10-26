terminal-packages:
  pkg.installed:
    - pkgs:
      - rxvt-unicode
      - xterm
      - fonts-dejavu-core
      - fonts-symbola
      - fonts-font-awesome
      - fonts-powerline
      - fontconfig
      - locales
      - curl
      - ca-certificates

/usr/share/fonts/truetype/nerd-fonts:
  file.directory:
    - mode: '0755'
    - makedirs: true

terminal-nerd-font:
  cmd.run:
    - name: >-
        curl --fail --location --retry 3
        --proxy http://127.0.0.1:8082 --noproxy ''
        --output /var/cache/DejaVuSansMNerdFontMono-Regular.ttf
        https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontMono-Regular.ttf &&
        echo 'f0ad5d5e932a02c7c0169b67bb4a7a1d8ecde33ab42c7d584b4c91cebef98300  /var/cache/DejaVuSansMNerdFontMono-Regular.ttf' | sha256sum --check &&
        install -m 0644 /var/cache/DejaVuSansMNerdFontMono-Regular.ttf
        /usr/share/fonts/truetype/nerd-fonts/DejaVuSansMNerdFontMono-Regular.ttf
    - unless: >-
        echo 'f0ad5d5e932a02c7c0169b67bb4a7a1d8ecde33ab42c7d584b4c91cebef98300  /usr/share/fonts/truetype/nerd-fonts/DejaVuSansMNerdFontMono-Regular.ttf' | sha256sum --check --status
    - require:
      - pkg: terminal-packages
      - file: /usr/share/fonts/truetype/nerd-fonts

terminal-font-cache:
  cmd.run:
    - name: fc-cache -f
    - onchanges:
      - cmd: terminal-nerd-font

terminal-locale:
  locale.present:
    - name: en_US.UTF-8
    - require:
      - pkg: terminal-packages

{% for mode in ['light', 'dark'] %}
/etc/urxvt/shotormorgh-{{ mode }}.Xresources:
  file.managed:
    - source: salt://shotor/morgh-theme/terminal/urxvt/shotormorgh-{{ mode }}.Xresources
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
{% endfor %}

/etc/urxvt/config:
  file.symlink:
    - target: /etc/urxvt/shotormorgh-dark.Xresources
    - require:
      - file: /etc/urxvt/shotormorgh-dark.Xresources

/etc/X11/app-defaults/URxvt:
  file.managed:
    - source: salt://shotor/morgh-theme/terminal/urxvt/shotormorgh-dark.Xresources
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: terminal-packages

/usr/bin/urxvt-terminal:
  file.managed:
    - source: salt://shotor/terminal/files/urxvt-terminal
    - mode: '0755'
    - require:
      - pkg: terminal-packages
      - file: /etc/urxvt/config
      - file: /etc/X11/app-defaults/URxvt
      - cmd: terminal-font-cache

urxvt-terminal-alternative:
  alternatives.install:
    - name: x-terminal-emulator
    - link: /usr/bin/x-terminal-emulator
    - path: /usr/bin/urxvt-terminal
    - priority: 60
    - require:
      - file: /usr/bin/urxvt-terminal

default-terminal:
  alternatives.set:
    - name: x-terminal-emulator
    - path: /usr/bin/urxvt-terminal
    - require:
      - alternatives: urxvt-terminal-alternative
