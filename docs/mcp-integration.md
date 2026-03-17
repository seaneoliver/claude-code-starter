# MCP Integration Pattern

How to wrap any MCP tool as a Claude Code skill. This guide uses WorkIQ as a worked example.

---

## What Is an MCP Skill?

MCP (Model Context Protocol) servers expose tools that Claude can call. A Claude Code skill wraps an MCP tool with:
- A consistent invocation trigger ("use when...")
- Output formatting rules
- Prerequisites documentation

This gives you predictable behavior every time you ask Claude to use the tool.

---

## The Pattern

### 1. Configure the MCP server in `settings.json`

```json
{
  "pluginConfigs": {
    "your-plugin": {
      "mcpServers": {
        "your-tool": {
          "command": "path/to/your-tool",
          "args": ["mcp"],
          "autoapprove": [
            "mcp__your-tool__method_name"
          ]
        }
      }
    }
  }
}
```

The `autoapprove` list uses the format `mcp__<server>__<tool>` (double underscores).

### 2. Create the skill file

Create `.claude/skills/your-tool/SKILL.md`:

```markdown
---
name: your-tool
description: [What it does]. Use when [specific trigger].
user-invocable: true
allowed-tools: mcp__your-tool__method_name
---

# Your Tool

## When to Use
[Specific trigger phrases that will invoke this skill]

## Steps
1. Pass user's query to `mcp__your-tool__method_name`
2. Return result BLUF-first
3. [Any post-processing rules]

## Output Rules
- [Formatting requirements]
- [What to do when tool returns nothing]
```

### 3. Test it

```
User: [trigger phrase]
Claude: [Uses Skill(your-tool) → calls mcp__your-tool__method_name → returns result]
```

---

## WorkIQ Example

WorkIQ is a Microsoft 365 productivity intelligence service. The worked example:

### MCP server config
```json
{
  "mcpServers": {
    "workiq": {
      "command": "workiq-mcp-server",
      "args": ["--auth", "microsoft"],
      "autoapprove": ["mcp__workiq__ask_work_iq"]
    }
  }
}
```

### Skill trigger
- "ask workiq [question]"
- "check my meeting load"
- "what does my collaboration data show"

### Output pattern
Answer first, supporting data second. No hedging. Preserve tables and metrics as returned by the tool.

---

## Common MCP Servers

| Tool | Use case | MCP package |
|------|----------|-------------|
| GitHub | Issues, PRs, code search | `@modelcontextprotocol/server-github` |
| Filesystem | File read/write outside project | `@modelcontextprotocol/server-filesystem` |
| Postgres | Direct DB queries | `@modelcontextprotocol/server-postgres` |
| Brave Search | Web search | `@modelcontextprotocol/server-brave-search` |
| Google Calendar | Calendar events | Various implementations |

Find more at: https://github.com/modelcontextprotocol/servers

---

## Troubleshooting

**Skill not triggering**: Check that `allowed-tools` matches the exact MCP tool name (format: `mcp__server__tool`).

**Tool not found**: Verify the MCP server is running and listed in `settings.json` under `mcpServers`.

**autoapprove not working**: The key format is `mcp__<server>__<tool>` with double underscores. Single underscores won't match.
