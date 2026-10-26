include:
  - shotor.network.tray-theme

nextcloud-tray-packages:
  pkg.installed:
    - name: qt6-gtk-platformtheme

/etc/environment:
  file.keyvalue:
    - key_values:
        QT_QPA_PLATFORMTHEME: gtk3
    - separator: '='
    - append_if_not_found: true

/usr/share/morgh/nextcloud-tray:
  file.recurse:
    - source: salt://shotor/nextcloud/files/tray
    - file_mode: '0644'
    - dir_mode: '0755'

nextcloud-tray-icons:
  cmd.run:
    - name: /usr/libexec/morgh/tray-icons nextcloud
    - stateful: true
    - require:
      - pkg: nextcloud-packages
      - pkg: nextcloud-tray-packages
      - file: /usr/share/morgh/nextcloud-tray
      - file: /usr/libexec/morgh/tray-icons
