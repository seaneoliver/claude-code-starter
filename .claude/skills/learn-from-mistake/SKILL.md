---
name: learn-from-mistake
description: Transform mistakes into permanent CLAUDE.md learnings using the Reflect-Abstract-Generalize-Document pattern. Use when Claude makes an error, user says "learn from this", or a pattern keeps causing friction.
argument-hint: "[description of mistake or feedback]"
user-invocable: true
allowed-tools: Read Edit
---

# learn-from-mistake: Auto-Improving CLAUDE.md System

> **Before returning results, verify:** Am I answering what was asked or a misinterpretation? Did I use the correct data source (local vault vs external)? Have I attempted more than 3 tool calls without progress? If so, stop, state what's blocking, and propose 2 alternative approaches.

Transform mistakes into permanent learning using the Reflect-Abstract-Generalize-Document pattern.

## When to Use This Skill

Use this skill when:
- You made a mistake and the user corrected you
- You caught yourself violating a rule
- You discovered a better way to do something
- A pattern keeps causing friction
- User provides feedback on your output

**Trigger phrase**: "learn from this" or "add this to learnings"

## How It Works

This skill guides you through the 4-step learning loop, then adds the result to the `## Continuous Learning` rolling window in your project's `CLAUDE.md`.

1. **Reflect** - What went wrong or what could be better?
2. **Abstract** - What is the general pattern?
3. **Generalize** - What rule prevents this in the future?
4. **Document** - Add to the rolling window in CLAUDE.md

## Instructions

When this skill activates:

### Step 1: Understand the Mistake

Ask the user (if not already clear):
- What went wrong or what needs improvement?
- What was the context?
- What was the impact?

### Step 2: Apply the Learning Loop

**Internally process** (don't display this analysis, just think through it):

1. **REFLECT**: What specifically went wrong?
   - What did I do?
   - What should I have done?
   - Why did this happen?

2. **ABSTRACT**: What's the general pattern?
   - Is this about writing style, tool usage, process, or something else?
   - Have I seen similar issues before?

3. **GENERALIZE**: What rule prevents this?
   - Write a clear, actionable rule
   - Explain WHY it matters (not just WHAT to do)
   - Make it specific enough to be useful but general enough to apply broadly

### Step 3: Check for Redundancy

Read the project's `CLAUDE.md` to ensure:
- This rule doesn't already exist in the Continuous Learning section
- It doesn't conflict with existing rules
- It adds genuine value

### Step 4: Format the Learning

Use the rolling window format:

```
- **[Short title]** [YYYY-MM-DD]: [One-sentence rule. Include the why and the trigger context.]
```

Examples:
```
- **Read before editing** [2026-03-01]: Always read a file completely before making edits. Partial reads lead to dropped context and incorrect assumptions.
- **Confirm scope before executing** [2026-03-01]: "Yes" to one thing is not a license for broader changes. Confirm scope explicitly on multi-step tasks.
```

### Step 5: Add to CLAUDE.md

Use the Edit tool to:
1. Insert the new entry at the **top** of the `Key learned patterns (last 5):` list in `## Continuous Learning`
2. Remove the **oldest entry** at the bottom if the list exceeds 7 entries

Target file: `CLAUDE.md` in the current project root.
Target section: `## Continuous Learning`

### Step 6: Confirm

Show the user:
```
Learning added to CLAUDE.md

**What I learned:**
[The rule in plain language]

This will prevent [the specific problem] going forward.
```

## Quality Checks

Before adding a rule, verify:
- [ ] Rule is specific and actionable (not vague advice)
- [ ] Includes WHY, not just WHAT
- [ ] Doesn't duplicate existing entries in Continuous Learning section
- [ ] Has today's date in [YYYY-MM-DD] format
- [ ] New entry added at TOP, oldest trimmed if list exceeds 7

## Important Notes

- **One learning at a time** - Don't batch multiple learnings into one entry
- **Evidence-based** - Every rule should come from actual experience, not speculation
- **Rolling window** - The list stays at ~7 entries. Adding one means removing the oldest.
