## Usage

Two ways in, combinable:

```json
"features": {
    "ghcr.io/shotor/devcontainer/features/import-ca:0": {
        "urls": "https://ca.example.internal/roots.pem#3f2a...c9",
        "certs": "-----BEGIN CERTIFICATE-----\nMIIB...\n-----END CERTIFICATE-----"
    }
},
"mounts": [
    { "type": "bind", "source": "${localWorkspaceFolder}/.devcontainer/volumes/ca-certificates", "target": "/usr/local/share/ca-certificates" }
]
```

`certs` and `urls` are imported when the image builds, into the distro's directory (`/usr/share/ca-certificates/import-ca/<fingerprint>.crt`, listed in `/etc/ca-certificates.conf`), so a mount can't hide them. `/usr/local/share/ca-certificates` is Debian's directory for locally added CAs: keep the project's certificates there as `*.crt` files (PEM; a bundle in one file is fine) by mounting a directory of the project, and the feature's entrypoint runs `update-ca-certificates` at every start, so what the mount holds is what is trusted.

A fingerprint is the SHA-256 of the certificate's DER, as `step certificate fingerprint` or `openssl x509 -noout -fingerprint -sha256` print it (colons, case and a `sha256:` prefix don't matter). With a pin the fetch skips TLS verification, since the server is usually the CA itself, whose certificate the store can't verify yet; every certificate in the response then has to match one of the pins. Without a pin the URL must be verifiable with the store as it is (a public host works).

Everything ends up in `/etc/ssl/certs/ca-certificates.crt`, which openssl, curl, git and Python's `ssl` use. For tools with a store of their own the feature sets `NODE_EXTRA_CA_CERTS` to `/etc/ssl/import-ca.pem`, a bundle of just the imported certificates, and `REQUESTS_CA_BUNDLE` to the system bundle. `import-ca --certs PEM | --url URL[#fp]` can be run by hand as root at any time; without arguments it refreshes.
