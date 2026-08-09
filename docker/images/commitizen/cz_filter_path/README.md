# cz-filter-path

Path-based changelog filtering for [Commitizen](https://commitizen-tools.github.io/commitizen/), designed for monorepos.

In a monorepo, components are often released independently:

```text
packages/
├── api/
│   └── .cz.toml
├── cli/
│   └── .cz.toml
└── web/
    └── .cz.toml
```

When releasing `cli`, its changelog should only contain commits that changed `packages/cli`.

`cz-filter-path` adds this behavior while keeping Commitizen's Conventional Commits parsing and changelog generation.

## Usage

Configure the plugin:

```toml
[tool.commitizen]
name = "cz_filter_paths"
version = "0.0.1"
filter_path = "packages/cli"
```

Then use Commitizen normally:

```bash
cz changelog
```

The path can also be provided dynamically:

```bash
CZ_FILTER_PATH="packages/cli" cz changelog
```

`CZ_FILTER_PATH` takes precedence over `component_path`.

If no path is configured, commits are not filtered.

## License

MIT
