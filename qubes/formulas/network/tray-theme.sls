tray-icon-packages:
  pkg.installed:
    - pkgs:
      - python3
      - librsvg2-common

/usr/libexec/morgh/tray-icons:
  file.managed:
    - source: salt://shotor/network/files/tray-icons
    - mode: '0755'
    - makedirs: true
    - require:
      - pkg: tray-icon-packages

/etc/gtk-3.0:
  file.directory:
    - mode: '0755'

/etc/gtk-3.0/settings.ini:
  ini.options_present:
    - sections:
        Settings:
          gtk-icon-theme-name: MorghTray
    - separator: '='
    - require:
      - file: /etc/gtk-3.0

