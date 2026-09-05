
# import-ca (import-ca)

Private CA certificates for the trust store, as many as you like: PEM text and URLs (optionally pinned by SHA-256 fingerprint) at build time, and whatever *.crt files are in /usr/local/share/ca-certificates at each start — mount the project's there.

## Example Usage

```json
"features": {
    "ghcr.io/shotor/devcontainer/features/import-ca:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| certs | PEM certificates to trust at build time, concatenated (a bundle holds any number). | string | - |
| urls | URLs serving PEM certificates, fetched at build time, separated by whitespace. `url#fingerprint[,fingerprint...]` pins what the URL may return by SHA-256 fingerprint and skips TLS verification for that fetch; a URL without a fingerprint is fetched with normal verification. | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
