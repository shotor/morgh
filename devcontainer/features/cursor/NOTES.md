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

The API key can be stored in:

```text
~/.config/cursor/auth.json
```

The file contains:

```json
{
  "apiKey": "your-api-key"
}
```

The included `agent-auth` helper can create this file from the `CURSOR_API_KEY` environment variable:

```bash
CURSOR_API_KEY="your-api-key" agent-auth
```

This is particularly useful with devcontainer lifecycle commands or secret injection. For example:

```json
{
  "postCreateCommand": "agent-auth"
}
```

If `CURSOR_API_KEY` is available to the lifecycle command, `agent-auth` writes it to `~/.config/cursor/auth.json`.

If `CURSOR_API_KEY` is not set, `agent-auth` exits successfully without modifying the authentication configuration.

When `agent` is started, the wrapper automatically reads `apiKey` from `~/.config/cursor/auth.json` if `CURSOR_API_KEY` is not already present in the environment.

### Precedence

If both methods are configured, the environment variable takes precedence:

1. `CURSOR_API_KEY` environment variable
2. `~/.config/cursor/auth.json`

If neither is configured, `agent` starts normally without setting `CURSOR_API_KEY`.
