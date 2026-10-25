include:
  - shotor.ctap

ctap-response-command:
  file.replace:
    - name: /usr/lib/python3/dist-packages/qubesctap/client/hidemu.py
    - pattern: 'await self\.write_ctaphid_response\(cid, CTAPHID\.MSG,(\s+bytes\(await handle\(request\)\)\))'
    - repl: 'await self.write_ctaphid_response(cid, CTAPHID.CBOR if ctaphid == "cbor" else CTAPHID.MSG,\1'
    - count: 1
    - require:
      - pkg: ctap-packages

ctap-discoverable-client:
  file.replace:
    - name: /usr/lib/python3/dist-packages/qubesctap/client/qctap_proxy.py
    - pattern: 'for qrexec_arg in cbor\.qrexec_args:'
    - repl: 'for qrexec_arg in (tuple(cbor.qrexec_args) or ("discover",)):'
    - count: 1
    - require:
      - pkg: ctap-packages

qubes-ctapproxy@sys-fido.service:
  service.enabled:
    - require:
      - pkg: ctap-packages
      - file: ctap-response-command
      - file: ctap-pin-field-mapping
      - file: ctap-discoverable-client
      - service: qubes-ctapproxy@sys-usb.service
