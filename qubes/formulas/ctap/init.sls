ctap-packages:
  pkg.installed:
    - pkgs:
      - qubes-ctap: '>=2.0.8'

ctap-pin-field-mapping:
  file.replace:
    - name: /usr/lib/python3/dist-packages/qubesctap/ctap2.py
    - pattern: '(    permissions_rpid: Optional\[str\]\n)(?=\s*def execute\(self, ctap: Ctap2\) -> ClientPINResponse:)'
    - repl: |
        \1
            @classmethod
            def _get_field_key(cls, field: Field) -> int:
                return {"permissions": 9, "permissions_rpid": 10}.get(
                    field.name, super()._get_field_key(field))

    - count: 1
    - require:
      - pkg: ctap-packages

ctap-discoverable-request:
  file.replace:
    - name: /usr/lib/python3/dist-packages/qubesctap/protocol.py
    - pattern: '        if credential_id_hash is not None:\n            allowed = list\(result\.qrexec_args\)'
    - repl: '        if credential_id_hash == "discover":\n            if not isinstance(result.data, ctap2.GetAssertion) or result.data.allow_list:\n                return req_cls(InvalidRequest(reject))\n        elif credential_id_hash is not None:\n            allowed = list(result.qrexec_args)'
    - count: 1
    - require:
      - pkg: ctap-packages

qubes-ctapproxy@sys-usb.service:
  service.dead:
    - enable: false
    - require:
      - pkg: ctap-packages
