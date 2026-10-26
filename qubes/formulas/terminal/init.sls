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
