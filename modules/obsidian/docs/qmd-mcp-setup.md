# qmd MCP Setup — Vault Search from Claude Code

`qmd` is a local MCP server that indexes your Obsidian vault and lets Claude search it semantically and by keyword.

## Install qmd

```bash
# Using bun (recommended)
bun install -g qmd

# Or npm
npm install -g @qmd/cli
```

## Configure in settings.json

Add to `~/.claude/settings.json` under `pluginConfigs`:

```json
{
  "pluginConfigs": {
    "qmd@your-marketplace": {
      "mcpServers": {
        "qmd": {
          "command": "/path/to/qmd",
          "args": ["mcp"],
          "autoapprove": [
            "mcp__qmd__search",
            "mcp__qmd__vsearch",
            "mcp__qmd__query",
            "mcp__qmd__get",
            "mcp__qmd__multi_get",
            "mcp__qmd__status"
          ]
        }
      }
    }
  }
}
```

**Note on autoapprove format:** The key format is `mcp__<server>__<tool>` (double underscores). This is a common gotcha — single underscores won't match.

## Point qmd at your vault

```bash
qmd index /path/to/your/vault
```

## Test it

In Claude Code:
```
Search my vault for notes about [topic]
```

Claude will use `mcp__qmd__search` to find relevant notes.

## Available tools

| Tool | Purpose |
|------|---------|
| `mcp__qmd__search` | Keyword search |
| `mcp__qmd__vsearch` | Semantic/vector search |
| `mcp__qmd__query` | Structured query |
| `mcp__qmd__get` | Get a specific note by path |
| `mcp__qmd__multi_get` | Get multiple notes |
| `mcp__qmd__status` | Check index status |

## Troubleshooting

**Search returns nothing:** Run `qmd index` again to reindex after adding notes.

**Command not found:** Ensure qmd is in your PATH. May need to restart terminal after install.

**Windows path issues:** Use forward slashes or escaped backslashes in the command path.
