# 🐪🦀 shotor-rust

## Installation

Using `npx`:

```sh
npx skills add https://github.com/shotor/morgh/tree/main/agents/skills/shotor-rust
```

Using `bunx`:

```sh
bunx skills add https://github.com/shotor/morgh/tree/main/agents/skills/shotor-rust
```

Or install the CLI globally:

```sh
pnpm add -g skills
skills add https://github.com/shotor/morgh/tree/main/agents/skills/shotor-rust
```

### Manual

Clone the repository, then copy or symlink the skill directory into your agent's skills directory.

```sh
git clone https://github.com/shotor/morgh.git ~/.local/share/morgh

ln -s ~/.local/share/morgh/agents/skills/shotor-rust ~/.claude/skills/shotor-rust
ln -s ~/.local/share/morgh/agents/skills/shotor-rust ~/.codex/skills/shotor-rust
# pi and cursor
ln -s ~/.local/share/morgh/agents/skills/shotor-rust ~/.agents/skills/shotor-rust
```
