<!--
  EXAMPLE MCP SKILL — requires Microsoft 365 / WorkIQ access.

  This file is sourced from the official microsoft/work-iq repo:
  https://github.com/microsoft/work-iq/tree/main/plugins/workiq/skills/workiq

  Use this file as a reference pattern for wrapping any MCP tool as a
  Claude Code skill. See docs/mcp-integration.md for install steps and
  the general pattern for adapting this to your own MCP tools.
-->

---
name: workiq
description: Query Microsoft 365 Copilot for workplace intelligence - emails, meetings, documents, Teams messages, and people information. USE THIS SKILL for ANY workplace-related question where the answer likely exists in Microsoft 365 data. This includes questions about what someone said, shared, or communicated; meetings, emails, messages, or documents; priorities, decisions, or context from colleagues; organizational knowledge; project status; team activities; or any information that would be in Outlook, Teams, SharePoint, OneDrive, or Calendar. When in doubt about workplace context, try WorkIQ first. Trigger phrases include "what did [person] say", "what are [person]'s priorities", "top of mind from [person]", "what was discussed", "find emails about", "what meetings", "what documents", "who is working on", "what's the status of", "any updates on", etc.
user-invocable: true
allowed-tools: mcp__workiq__ask_work_iq
---

# WorkIQ

WorkIQ connects Claude to Microsoft 365 Copilot, providing access to workplace intelligence grounded in organizational data, connected through Microsoft Graph, and personalized through memory and context.

## CRITICAL: When to Use This Skill

**USE WorkIQ for ANY workplace-related question.** If the answer might exist in Microsoft 365 data, try WorkIQ first.

**ALWAYS use WorkIQ when the user asks about:**

| User Question Pattern | Example | Action |
|-----------------------|---------|--------|
| What someone said/shared/communicated | "What did Rob say about X?" | `ask_work_iq` |
| Someone's priorities/concerns/focus | "What's top of mind for Sarah?" | `ask_work_iq` |
| Meeting content/decisions/action items | "What was decided in yesterday's meeting?" | `ask_work_iq` |
| Email content or conversations | "Any emails from John about the deadline?" | `ask_work_iq` |
| Teams messages or chats | "What did the team discuss about the release?" | `ask_work_iq` |
| Document locations or content | "Where is the design doc?" | `ask_work_iq` |
| Colleague expertise or ownership | "Who owns the billing system?" | `ask_work_iq` |
| Calendar/schedule information | "What meetings do I have today?" | `ask_work_iq` |
| Organizational context | "What are the team's Q1 goals?" | `ask_work_iq` |
| Project status or updates | "What's the status of Project X?" | `ask_work_iq` |
| Team activities or work | "What is the team working on?" | `ask_work_iq` |
| Any workplace/work-related context | "Any updates I should know about?" | `ask_work_iq` |

**DO NOT say "I don't have access to emails/meetings/messages"** — use WorkIQ instead.

**When in doubt, use WorkIQ.** It's better to query and get no results than to miss workplace context.

## Configuration

Authentication is automatic with the connected user's Microsoft 365 credentials. See `docs/mcp-integration.md` for MCP server setup.

## MCP Tool

| Tool | Parameters |
|------|------------|
| `ask_work_iq` | `{ "question": "<your question>" }` |

## Common Use Cases

### What Someone Is Thinking/Sharing

| Tool | Parameters |
|------|------------|
| `ask_work_iq` | `{ "question": "What are the latest top of mind from [name] I should be aware of?" }` |
| `ask_work_iq` | `{ "question": "What has [name] been focused on lately?" }` |
| `ask_work_iq` | `{ "question": "What concerns has my manager raised recently?" }` |

### Find Experts and People

| Tool | Parameters |
|------|------------|
| `ask_work_iq` | `{ "question": "Who is the expert on [topic] in our team?" }` |
| `ask_work_iq` | `{ "question": "Who should I talk to about [system]?" }` |
| `ask_work_iq` | `{ "question": "Who worked on [feature]?" }` |

### Retrieve Meeting Context

| Tool | Parameters |
|------|------------|
| `ask_work_iq` | `{ "question": "What decisions were made in my meeting last week about [topic]?" }` |
| `ask_work_iq` | `{ "question": "Summarize the discussion from yesterday's [meeting name]" }` |
| `ask_work_iq` | `{ "question": "What action items came out of [meeting]?" }` |

### Find Emails and Messages

| Tool | Parameters |
|------|------------|
| `ask_work_iq` | `{ "question": "Any recent emails from [name] about [topic]?" }` |
| `ask_work_iq` | `{ "question": "What did the team discuss in Teams about [topic]?" }` |
| `ask_work_iq` | `{ "question": "Summarize my unread messages from today" }` |

### Locate Documents

| Tool | Parameters |
|------|------------|
| `ask_work_iq` | `{ "question": "Find the design doc for [project]" }` |
| `ask_work_iq` | `{ "question": "What's the latest spec for [project]?" }` |
| `ask_work_iq` | `{ "question": "Where is the API documentation for [service]?" }` |

### Understand Priorities

| Tool | Parameters |
|------|------------|
| `ask_work_iq` | `{ "question": "Based on discussions with my manager, what are my top priorities?" }` |
| `ask_work_iq` | `{ "question": "What are the team's goals for this quarter?" }` |
| `ask_work_iq` | `{ "question": "What's blocking the release?" }` |

## Output Rules

- Answer first, context second
- Preserve structured data (tables, metrics, lists) as returned
- If WorkIQ returns nothing: say "WorkIQ returned no data for that query" — don't pad
- No hedging (might, possibly, seems like)
- Short sentences where possible
- Don't narrate the tool call — return the answer
