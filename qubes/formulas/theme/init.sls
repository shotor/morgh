/usr/bin/morgh-theme:
  file.managed:
    - source: salt://shotor/theme/files/morgh-theme
    - mode: '0755'

{% for directory in ['terminal/urxvt', 'terminal/tmux', 'editor/vim'] %}
/usr/share/morgh/themes/{{ directory }}:
  file.recurse:
    - source: salt://shotor/morgh-theme/{{ directory }}
    - dir_mode: '0755'
    - file_mode: '0644'
{% endfor %}

/etc/xdg/autostart/morgh-theme.desktop:
  file.managed:
    - makedirs: true
    - mode: '0644'
    - contents: |
        [Desktop Entry]
        Type=Application
        Name=Morgh theme selection
        Exec=/usr/bin/morgh-theme refresh
        NoDisplay=true
