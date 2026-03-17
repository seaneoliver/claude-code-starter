# Obsidian Module

Optional add-on for Claude Code users who also use Obsidian as their knowledge base.

## What This Module Provides

- **Vault-aware CLAUDE.md** — context that references your vault structure
- **Note templates** — Daily notes, meeting notes, people dossiers
- **qmd MCP setup** — Full-text search across your vault from Claude Code
- **setup-obsidian.sh** — Installs everything with one command

## Prerequisites

- Obsidian installed with an existing vault
- Main `setup.sh` already run (installs core Claude Code config)
- Node.js (for qmd, optional)

## Quick Start

```bash
# Run after ./setup.sh
./modules/obsidian/setup-obsidian.sh --vault /path/to/your/vault
```

Or on Windows:
```powershell
.\modules\obsidian\setup-obsidian.ps1 -VaultPath "C:\path\to\vault"
```

## What Gets Installed

| File | Destination | Purpose |
|------|-------------|---------|
| `templates/Daily-Note.md` | `vault/Templates/` | Daily note template |
| `templates/Meeting-Note.md` | `vault/Templates/` | Meeting note template |
| `templates/People-Dossier-Template.md` | `vault/Templates/` | Contact dossier |

## qmd Setup (Optional)

`qmd` is an MCP server that gives Claude full-text search over your Obsidian vault. See `docs/qmd-mcp-setup.md`.

## Customizing Templates

After setup, edit the templates in `vault/Templates/` directly. The templates use Obsidian's Templater plugin syntax — adjust to your setup.
