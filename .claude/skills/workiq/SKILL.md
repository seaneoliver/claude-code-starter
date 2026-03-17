<!--
  EXAMPLE MCP SKILL — requires Microsoft 365 / WorkIQ access.

  This file demonstrates how to wrap an MCP tool as a Claude Code skill.
  If you don't have WorkIQ, use this as a reference pattern for your own
  MCP integrations. See docs/mcp-integration.md for the general approach.

  To adapt this pattern:
  1. Replace `mcp__workiq__ask_work_iq` with your MCP tool name
  2. Update the description to match your tool's purpose
  3. Adjust the output rules to fit your use case
-->

---
name: workiq
description: Query Microsoft 365 work intelligence data via WorkIQ. Use when asking about work activity, collaboration patterns, meeting load, focus time, or any Microsoft 365 productivity insights. Requires Microsoft 365 / WorkIQ access.
user-invocable: true
allowed-tools: mcp__workiq__ask_work_iq
author: Claude Code Starter
version: 1.0.0
date: 2026-03-01
---

# WorkIQ Chat

Query Microsoft 365 work data in plain language.

## Prerequisites

This skill requires:
- Microsoft 365 account
- WorkIQ MCP server configured in your Claude Code settings
- See `docs/mcp-integration.md` for setup instructions

## When to Use

Invoke when the user says:
- "ask workiq [question]"
- "check my work data"
- "what does workiq say about..."
- Any question about meetings, focus time, collaboration, or productivity patterns

## Steps

1. Pass the user's question to `mcp__workiq__ask_work_iq` — don't rephrase unless clarification is needed
2. Return the result BLUF-first: bottom line in one sentence, then supporting detail
3. Preserve structured data (tables, metrics, lists) as returned
4. If WorkIQ returns nothing: say "WorkIQ returned no data for that query" — don't pad
5. Don't narrate the tool call. Don't describe what you're doing. Return the answer.

## Output Rules

- Answer first, context second
- Short sentences (under 12 words where possible)
- No hedging (might, possibly, seems like)
- No corporate filler
- Contractions are fine
