---
name: done
description: Use when ending a session and wanting to capture key decisions, open questions, and follow-up actions from the conversation into a dated markdown file.
user-invocable: true
allowed-tools: Bash, Read, Write, Edit
---

# Done - Session Capture

> **Before returning results, verify:** Am I answering what was asked or a misinterpretation? Have I attempted more than 3 tool calls without progress? If so, stop, state what's blocking, and propose 2 alternative approaches.

## Overview

Captures the current session into a structured markdown file. Includes key decisions, open questions, follow-up actions, and files changed.

## Instructions

When invoked:

### Step 1: Get metadata

Get today's date and a session identifier. On Windows you can run:

```bash
powershell -Command "Get-Date -Format 'yyyy-MM-dd'"
```

Or use your platform's equivalent date command.

### Step 2: Review the conversation

Extract:

- **Key Decisions** - What was agreed, chosen, or configured
- **Open Questions** - Anything raised but not fully resolved
- **Follow-Ups** - Action items for the user's next session
- **Files Changed** - Any files created or modified

### Step 3: Write the file

Save to your configured sessions directory. Default: `Logs/Sessions/YYYY-MM-DD-Session.md`

Configure your preferred path in your project CLAUDE.md:
```
Session log location: `path/to/Sessions/`
```

If a file for today already exists, append with a `---` separator and a timestamp header.

```markdown
---
date: YYYY-MM-DD
type: session-notes
tags: [session, notes]
---

# Session Notes - YYYY-MM-DD

## Key Decisions

- [decision]

## Open Questions

- [question]

## Follow-Ups

- [ ] [action item]

## Files Changed

- `[path]` - [what changed]

---
*Captured by /done*
```

### Step 4: Confirm

Tell the user the full file path where it was saved.

## Notes

- Omit any section that has nothing to capture (no empty bullets)
- Keep bullets tight, one line each
- Configure your sessions directory in your project CLAUDE.md for consistent file placement
