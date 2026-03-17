---
name: dayplan
description: Create a prioritized daily plan from backlog and calendar context. Use when starting the day, saying "plan my day", or needing to prioritize P0/P1 tasks.
author: Claude Code
version: 2.0.0
date: 2026-02-20
user-invocable: true
allowed-tools: Read
---

# Day Planning Skill

> **Before returning results, verify:** Am I answering what was asked or a misinterpretation? Did I use the correct data source (local vault vs external)? Have I attempted more than 3 tool calls without progress? If so, stop, state what's blocking, and propose 2 alternative approaches.

## Steps

1. Read the backlog file (default: `BACKLOG.md` — adjust path in your project CLAUDE.md if different)
2. Read today's calendar using the Google Calendar MCP (`list-events` for today's date range) if available
3. Read the current task list from your Tasks directory to surface any P0/P1 items already created
4. Identify P0/P1 items and time-sensitive tasks
5. Output a prioritized plan for today with max 5 items
6. Do NOT start processing tasks — only output the plan

## Rules

- Do not modify any files unless explicitly asked
- Keep output concise: task name, priority, estimated time
- P0 = must do this week, max 3 total. P1 = this month, max 7 total.
- Surface calendar conflicts or deadline pressure where relevant

## Configuration

Set your backlog path in your project CLAUDE.md:
```
Backlog location: `path/to/BACKLOG.md`
```

If not configured, look for `BACKLOG.md` in the project root.
