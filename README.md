# claude-code-starter

A shareable Claude Code setup with an interactive setup script that generates personalized config from templates.

Clone it, run `setup.sh`, answer a few questions, and get a working Claude Code configuration personalized to you.

---

## What's Included

- **CLAUDE.md** — Global instructions: behavioral rules, planning protocol, self-improvement loop
- **SOUL.md** — Personality and style guide
- **AGENTS.md** — Subagent and planning workflow rules
- **plan-mode.md** — Structured plan review protocol
- **Curated skills** — learn, learn-from-mistake, dayplan, done, napkin, communication-patterns
- **Hooks + scripts** — Session validation, claudeception activator
- **Optional: Obsidian module** — Vault templates and qmd search integration
- **Optional: WorkIQ skill** — Example MCP integration pattern (requires Microsoft 365)

---

## Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/code) installed
- Bash (Mac/Linux) or PowerShell (Windows)
- Node.js (for validation scripts)

### 3 Steps

```bash
# 1. Clone
git clone https://github.com/oliversean_microsoft/claude-code-starter
cd claude-code-starter

# 2. Run setup
./setup.sh          # Mac/Linux
# OR
.\setup.ps1         # Windows PowerShell

# 3. Open a new Claude Code session
```

The setup script will ask for:
- Your name, role, and team
- Your platform (Mac/Windows/Linux)
- A brief description of your writing voice
- (Optional) Obsidian vault path
- (Optional) WorkIQ skill (Microsoft 365 only)

---

## What Gets Generated

| Generated File | From Template | Personalized With |
|---|---|---|
| `~/.claude/CLAUDE.md` | `templates/claude/CLAUDE.md.template` | Name, role, team, platform |
| `~/.claude/settings.json` | `templates/claude/settings.json.template` | Installed as-is |
| `~/.claude/settings.local.json` | `templates/claude/settings.local.json.template` | Installed as-is |
| `knowledge/voice-quick.md` | `templates/knowledge/voice-quick.md.template` | Name, voice scaffold |
| `knowledge/voice-guide.md` | `templates/knowledge/voice-guide.md.template` | Name, role, team |

---

## Skills

| Skill | Purpose |
|---|---|
| `learn` | Add behavioral rules to CLAUDE.md's rolling window |
| `learn-from-mistake` | 4-step loop: Reflect → Abstract → Generalize → Document |
| `dayplan` | Prioritized daily plan from backlog + calendar |
| `done` | Session wrap-up: capture decisions, follow-ups, files changed |
| `napkin` | In-session mistake log; persists across sessions in `.claude/napkin.md` |
| `communication-patterns` | Stakeholder messaging frameworks for difficult conversations |
| `workiq` *(optional)* | Example MCP integration — Microsoft 365 WorkIQ (requires M365 access) |

---

## Obsidian Module (Optional)

If you use Obsidian as your knowledge base:

```bash
./modules/obsidian/setup-obsidian.sh --vault /path/to/your/vault
```

Installs:
- Daily note template
- Meeting note template
- People dossier template

See `modules/obsidian/docs/qmd-mcp-setup.md` for vault search via Claude Code.

---

## Adding Your Own MCP Tools

See `docs/mcp-integration.md` for the pattern. WorkIQ is a worked example of wrapping any MCP server as a Claude Code skill.

---

## Customizing After Setup

### Your voice
Edit `~/.claude/skills/` knowledge files or add to your project vault.

### CLAUDE.md rules
The `## Continuous Learning` section in `~/.claude/CLAUDE.md` is your rolling window of behavioral rules. Use `/learn` to add rules as you work.

### Adding skills
Drop a new folder in `~/.claude/skills/your-skill/SKILL.md`. See existing skills for the frontmatter format.

---

## File Structure

```
claude-code-starter/
├── README.md
├── setup.sh                    # Bash interactive setup
├── setup.ps1                   # PowerShell version (Windows)
├── .gitignore
├── templates/
│   ├── claude/                 # Config templates ({{PLACEHOLDER}} vars)
│   │   ├── CLAUDE.md.template
│   │   ├── settings.json.template
│   │   └── settings.local.json.template
│   └── knowledge/              # Voice + context templates
│       ├── CONTEXT-INDEX.md.template
│       ├── voice-quick.md.template
│       └── voice-guide.md.template
├── .claude/                    # Ready-to-use Claude config
│   ├── SOUL.md
│   ├── AGENTS.md
│   ├── rules/plan-mode.md
│   ├── hooks/claudeception-activator.sh
│   ├── scripts/
│   │   ├── validate-config.cjs
│   │   └── validate-environment.sh
│   └── skills/
│       ├── learn/
│       ├── learn-from-mistake/
│       ├── dayplan/
│       ├── done/
│       ├── napkin/
│       ├── communication-patterns/
│       └── workiq/
├── modules/
│   └── obsidian/               # Optional vault integration
│       ├── README.md
│       ├── setup-obsidian.sh
│       ├── templates/
│       └── docs/qmd-mcp-setup.md
└── docs/
    └── mcp-integration.md      # How to build your own MCP skills
```

---

## Contributing

Improvements welcome — open an issue or PR.

---

## License

MIT
