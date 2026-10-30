/etc/qubes-rpc/morgh.Theme:
  file.managed:
    - source: salt://shotor/dom0/files/morgh.Theme
    - mode: '0755'
    - user: root
    - group: root

/etc/qubes/policy.d/30-morgh-theme.policy:
  file.managed:
    - mode: '0644'
    - user: root
    - group: root
    - contents: |
        morgh.Theme + @anyvm @adminvm allow user=root
        morgh.Theme * @anyvm @adminvm deny
        morgh.Theme * @anyvm @anyvm deny
