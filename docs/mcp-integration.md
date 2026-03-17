# MCP Integration Pattern

How to wrap any MCP tool as a Claude Code skill. This guide uses WorkIQ as a worked example — it's a real, installable Microsoft tool.

---

## WorkIQ — Setup & Installation

WorkIQ connects Claude to your Microsoft 365 data: emails, meetings, Teams messages, documents, and people.

**Source:** https://github.com/microsoft/work-iq

### Prerequisites

- Node.js 18+ (includes npx — verify with `node --version`)
- Microsoft 365 account
- Tenant admin consent on first use (see note below)

> **Admin consent:** WorkIQ needs Microsoft Graph permissions that require admin rights on your tenant. On first use, a consent dialog appears. If you're not an admin, share the [Tenant Administrator Enablement Guide](https://github.com/microsoft/work-iq/blob/main/ADMIN-INSTRUCTIONS.md) with your IT admin.

### Option A: VS Code (one click)

Click "Install in VS Code" from the [microsoft/work-iq README](https://github.com/microsoft/work-iq) — this adds WorkIQ as an MCP server automatically via the VS Code MCP config UI.

### Option B: Add to Claude Code `settings.json`

Add to `~/.claude/settings.json` under `mcpServers`:

```json
{
  "mcpServers": {
    "workiq": {
      "command": "npx",
      "args": ["-y", "@microsoft/workiq@latest", "mcp"],
      "tools": ["*"]
    }
  }
}
```

To auto-approve the tool without a permission prompt each time, add to your `autoapprove` list. Note the double-underscore format:

```json
"autoapprove": [
  "mcp__workiq__ask_work_iq"
]
```

> **Why npx?** Using `npx -y @microsoft/workiq@latest` means WorkIQ auto-updates on every run — no manual `npm update` needed.

### Option C: Global install

```bash
# Install
npm install -g @microsoft/workiq

# Accept EULA (required once)
workiq accept-eula

# Test directly
workiq ask -q "What meetings do I have tomorrow?"

# Start MCP server (Claude Code connects to this)
workiq mcp
```

To update a global install: `npm update -g @microsoft/workiq`

### Verify it's working

After setup, open Claude Code and try:

```
What meetings do I have tomorrow?
What did [colleague] say about [topic]?
Find emails from [name] about [topic]
```

---

## What You Can Query

| Data Type | Example |
|-----------|---------|
| Emails | "What did John say about the proposal?" |
| Meetings | "What's on my calendar tomorrow?" |
| Documents | "Find my recent PowerPoint presentations" |
| Teams | "Summarize today's messages in the Engineering channel" |
| People | "Who is working on Project Alpha?" |

---

## The General MCP Skill Pattern

The WorkIQ setup above is one instance of a reusable pattern. Here's how to apply it to any MCP server.

### 1. Configure the MCP server in `settings.json`

```json
{
  "mcpServers": {
    "your-tool": {
      "command": "npx",
      "args": ["-y", "your-package@latest", "mcp"]
    }
  }
}
```

The `autoapprove` list uses the format `mcp__<server>__<tool>` (double underscores — a common gotcha).

### 2. Create the skill file

Create `.claude/skills/your-tool/SKILL.md`:

```markdown
---
name: your-tool
description: [What it does]. Use when [specific trigger phrases].
user-invocable: true
allowed-tools: mcp__your-tool__method_name
---

# Your Tool

## When to Use
[Be explicit — list the exact trigger phrases and question patterns]

## Steps
1. Pass user's query to `mcp__your-tool__method_name`
2. Return result BLUF-first: bottom line first, detail second
3. If tool returns nothing: say so clearly — don't pad

## Output Rules
- [Formatting rules]
- [Tone rules]
```

### 3. Test it

```
User: [trigger phrase]
Claude: [invokes skill → calls MCP tool → returns result]
```

---

## Common MCP Servers

| Tool | Use case | Package |
|------|----------|---------|
| WorkIQ | Microsoft 365 intelligence | `@microsoft/workiq` |
| GitHub | Issues, PRs, code search | `@modelcontextprotocol/server-github` |
| Filesystem | File read/write outside project | `@modelcontextprotocol/server-filesystem` |
| Postgres | Direct DB queries | `@modelcontextprotocol/server-postgres` |
| Brave Search | Web search | `@modelcontextprotocol/server-brave-search` |

Find more at: https://github.com/modelcontextprotocol/servers

---

## Troubleshooting

**Skill not triggering:** Check that `allowed-tools` matches the exact MCP tool name (`mcp__server__tool` with double underscores).

**Tool not found:** Verify the MCP server is configured in `settings.json` under `mcpServers` and that the server process is running.

**autoapprove not working:** Format is `mcp__<server>__<tool>` — double underscores. Single underscores won't match.

**WorkIQ auth fails:** Run `workiq accept-eula` first. If it still fails, your tenant admin needs to grant consent — see [ADMIN-INSTRUCTIONS.md](https://github.com/microsoft/work-iq/blob/main/ADMIN-INSTRUCTIONS.md).

**WorkIQ: "Public Preview" warning:** The API may change. Check [microsoft/work-iq](https://github.com/microsoft/work-iq) for updates if something breaks.
