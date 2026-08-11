## Cursor API Key Authentication

Cursor Agent can use an API key for authentication. This feature supports two ways of providing the key.

### Option 1: Environment Variable

Set the `CURSOR_API_KEY` environment variable before running `agent`:

```bash
export CURSOR_API_KEY="your-api-key"
agent
```

You can also provide the key for a single invocation:

```bash
CURSOR_API_KEY="your-api-key" agent
```

When `CURSOR_API_KEY` is already set, it is passed directly to Cursor Agent.

### Option 2: Auth File

Alternatively, store the API key in:

```text
~/.config/cursor/auth.json
```

The file should contain:

```json
{
  "apiKey": "your-api-key"
}
```

The `agent` wrapper automatically reads the `apiKey` from this file and exports it as `CURSOR_API_KEY` before starting Cursor Agent.

### Precedence

If both methods are configured, the environment variable takes precedence:

1. `CURSOR_API_KEY` environment variable
2. `~/.config/cursor/auth.json`

If neither is configured, `agent` starts normally without setting `CURSOR_API_KEY`.
