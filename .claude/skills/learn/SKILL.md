---
name: learn
description: Self-improvement system for Claude to learn from mistakes and user feedback. Use when Claude makes an error, receives correction, or user says "add this to your learnings", "remember this", "don't do that again", or provides explicit feedback on behavior.
argument-hint: "[feedback or correction]"
context: fork
user-invocable: true
allowed-tools: Read, Write, Edit
---

# learn: Continuous Improvement System

This skill helps Claude learn from mistakes and improve over time by adding behavioral rules to CLAUDE.md's Continuous Learning section.

## When to Use This Skill

Invoke when:
1. User corrects Claude's behavior or output
2. User says "remember this", "add this to your learnings", "don't do that again"
3. Claude catches its own mistake and wants to prevent recurrence
4. User provides explicit feedback: "You should..." or "Next time..."

## Meta-Rules: How to Learn From Mistakes

When you make a mistake or discover a better way to do something, follow this process:

### The Learning Loop
1. **Reflect** - What went wrong or what could be better?
2. **Abstract** - What is the general pattern behind this specific instance?
3. **Generalize** - What rule would prevent this in the future?
4. **Document** - Add the rule to the appropriate section in CLAUDE.md

### Quality Standards for New Rules
- **Specific and Actionable** - "Check file existence before creating links" not "Be careful with links"
- **Context-Aware** - Explain WHY the rule matters, not just WHAT to do
- **Evidence-Based** - Reference what triggered the learning when adding the rule
- **No Redundancy** - Check if a similar rule already exists before adding

### When to Add a Learning
- You violated an existing rule and caught it
- User corrects you or provides feedback
- You discover a pattern that keeps causing friction
- You find a better way to accomplish something
- A tool or process changed and needs documentation

## Integration Note

This system works alongside Claudeception for complete continuous learning:
- **Rules (this skill)** - Behavioral patterns, style preferences, conventions
- **Skills (Claudeception)** - Technical procedures, debugging workflows, multi-step solutions

## Execution Instructions

When this skill is invoked:

1. **Read CLAUDE.md** to see existing learned rules and avoid duplicates
2. **Analyze the feedback** using The Learning Loop framework
3. **Draft the new rule** following Quality Standards
4. **Edit CLAUDE.md** to add the rule to `## Continuous Learning`
5. **Confirm to user** what was learned and where it was added

## Rolling Window Format

Use this format for new entries:
```
- **Short title** [YYYY-MM-DD]: One-sentence rule. Include the why and the trigger context.
```

Keep the list at ~7 entries max. Adding one means removing the oldest.

## Key Principles

- **Skills as On-Demand Context**: CLAUDE.md loads every session (context cost). Skills load on-demand (zero cost until needed). Put specialized knowledge in skills, not CLAUDE.md.
- **Emphasis Syntax as Priority Signal**: Use "IMPORTANT:" or "YOU MUST" on critical instructions when CLAUDE.md has many competing rules.
- **Pointers Over Copies**: Don't duplicate content across files. Point to authoritative source.
- **Skill Description WHEN Clause**: Skill descriptions must include "Use when [user action]" — concrete trigger phrases improve invocation accuracy.
