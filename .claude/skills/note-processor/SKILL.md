---
name: note-processor
description: Transforms messy meeting notes and voice transcripts into clear, actionable summaries. Action items first, warm conversational tone, thematic organization, Obsidian wikilinks. Use when the user has raw meeting notes, a voice transcript, or unstructured notes to clean up.
user-invocable: true
allowed-tools: Read, Write, Edit
author: Claude Code
version: 1.0.0
date: 2026-02-20
---

# Note Processor

Transform raw notes or voice transcripts into clean, actionable summaries that sound like a text from a friend — not a work memo.

## When to Use

Invoke when the user says:
- "process these notes"
- "clean up this transcript"
- "turn this into a meeting summary"
- "summarize my voice note"

## Steps

1. **Read the full input** before writing anything
2. **Auto-detect input type**: meeting notes or voice transcript
3. **Auto-detect meeting type** (see types below) and apply appropriate structure
4. **Extract all action items** with owners and timelines — these go first, always
5. **Identify 3-5 main themes** with descriptive headings (not generic labels)
6. **Write content** under each theme in conversational tone, preserving authentic language from the original
7. **Move tangential content** to an "Additional Thoughts" or "Side Notes" section
8. **Add Obsidian wikilinks** for people and projects
9. **Run quality checks** before finalizing

## Meeting Type Detection

Auto-detect and apply special structure for:
- **1:1 with {{YOUR_MANAGER}}**: My Updates / {{YOUR_MANAGER}}'s Feedback / My Action Items / {{YOUR_MANAGER}}'s Action Items / Career Development / Next 1:1 Topics
- **Governance Meeting**: Focus on process decisions, policy changes, stakeholder alignment
- **Stakeholder Alignment**: Topic / Starting Positions / Final Alignment / Remaining Gaps / Next Steps
- **MBR/QBR**: Metrics discussed, business performance insights, strategic decisions, commitments to leadership
- **Personal Thinking Session (Voice)**: Show progression of thought, organize by themes as ideas emerge, capture open questions
- **Team Meeting / Training / Other**: Standard structure below

## Output Format

### For Meeting Notes

```markdown
---
date: [YYYY-MM-DD]
type: meeting
attendees: ["[[Name One]]", "[[Name Two]]"]
tags: [tag1, tag2]
---

## Meeting Summary
**Date:** [date]
**Attendees:** [names as wikilinks]
**Purpose:** [inferred from context]

[2-3 sentence summary of outcome]

---

## Action Items

**High Priority:**
- [ ] [Action] - [[Owner]] - [Date]

**Standard:**
- [ ] [Action] - [[Owner]] - [Date]

---

## Key Decisions
- **[Decision]** - [[Owner]] - [why/context]

---

## [Descriptive Heading for Theme 1]
[Content in conversational tone]

## [Descriptive Heading for Theme 2]
[Content in conversational tone]

---

## Additional Thoughts
- [Tangential idea]
- [Future consideration]
```

### For Voice Transcripts

```markdown
# [Descriptive Title Based on Main Topic]

**Action Items**
1. [Action with owner and context]
2. [Action with owner and context]

## [Main Theme 1]
[Thorough summary in conversational tone]

## [Main Theme 2]
[Continue pattern — include direct quotes only if memorable]

## Side Notes
Things that came up but weren't the main focus:
- [Tangential idea]
- [Random connection]
```

## Tone Rules

**Sound like:** A text from a friend, not a work memo.

**Use:**
- Casual connectors: "So basically," "The thing is," "Here's what's interesting"
- Language similar to what was spoken
- Warm, personable, conversational writing

**Never use:**
- Corporate jargon (replace "leverage" with "use," "synergize" with "work together")
- Generic headings: "Discussion Points," "Key Takeaways," "Strategic Initiatives"
- Emojis
- Filler words (um, uh, like, you know) — clean these but preserve authentic phrasing

## Heading Rules

**Good headings** reflect natural conversation flow:
- "Why the current intake process isn't working"
- "Ideas for simplifying field access"
- "What came up in the conversation with [Name]"

**Bad headings** are generic:
- "Discussion Points"
- "Key Takeaways"
- "Strategic Initiatives"

## YAML Frontmatter — Attendees Syntax

**Always use proper array syntax:**
```yaml
attendees: ["[[Name One]]", "[[Name Two]]"]
```

**Never:**
```yaml
attendees: [[Name One]], [[Name Two]]
```

## Wikilinks

- People: `[[Colleague Name]]`, `[[Manager Name]]`
- Projects: `[[Project Name]]`, `[[Initiative Name]]`

## Quality Checks

- [ ] Action items at the very top, numbered or bulleted with owners and timelines?
- [ ] Tone sounds like a text from a friend?
- [ ] Language preserves authentic patterns from original?
- [ ] Thematic headings are descriptive (not generic)?
- [ ] Direct quotes only when memorable or uniquely insightful?
- [ ] Tangential ideas moved to Additional Thoughts / Side Notes?
- [ ] YAML frontmatter uses correct attendees array syntax?
- [ ] Wikilinks added for people and projects?
- [ ] No emojis, no corporate jargon?
- [ ] Meeting type auto-detected and appropriate structure applied?
