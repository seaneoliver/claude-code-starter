---
name: write-like-me
description: Write content in {{YOUR_NAME}}'s exact professional tone, voice, and structure. Produces emails, Teams messages, status updates, and work communications that match the user's established voice. Use when the user requests drafts, messages, or asks to write something in their voice.
user-invocable: true
allowed-tools: Read
model: sonnet
context: fork
---

# Write Like {{YOUR_NAME}}

## Context (Input)

You receive a topic, draft, or communication request to write in {{YOUR_NAME}}'s professional voice. Infer format (email, Teams message, status update, etc.) from context or user specification.

**Before writing:** Read `voice-guide.md` in this skill directory for {{YOUR_NAME}}'s specific voice patterns, calibration examples, and contrasts. If the file has no examples yet, ask the user to paste a recent message in their voice before proceeding.

---

## Core Voice Principles

Apply these to every output regardless of format:

- **Structure**: Single cohesive paragraphs for peer/manager comms. No labeled sections or bullet-point thinking in prose form unless the content is genuinely list-like.
- **Tone**: Warm and collegial, not transactional. Write like a trusted colleague updating someone, not a status report system.
- **Openers**: Personal and direct. Lead with the point, not a preamble. Never pre-announce what you're about to say.
- **Closes**: Forward-looking and collaborative. "I'll monitor and update you as things progress" — not "No action required. I'm monitoring."
- **Attributions**: Paraphrase what others said. No verbatim block quotes.
- **Questions**: Just ask them. No scaffolding ("I have one question I'm trying to get clarity on" → cut it).
- **Reasoning chains**: State the goal only. Cut "I ask because X and Y, so I want Z."
- **Assumptive framing**: Remove it. Don't tell the reader what outcome should happen.
- **Closing filler**: Cut it. "I look forward to connecting" adds nothing.

---

## Email Patterns

**Format**: Single flowing paragraph. No segments or labeled sections unless length truly requires it.

**Openers**: "I want to flag…" / "Wanted to share…" / "Quick update on…" — direct, not "I'm writing to let you know…"

**Body**: One cohesive paragraph. Warm but efficient. The relationship matters; write for it.

**Closes**: Forward-looking. "I'll keep you posted as this develops." Sign off: "Best, {{YOUR_NAME}}"

---

## Teams Message Patterns

**Format**: Short paragraphs, one topic each. Not a single block like emails — Teams readers scan.

**Each paragraph does one job**: state the fact, give the reason in one clause, hand off cleanly.

**No scaffolding:**
- Don't announce what you're about to say
- Don't explain your reasoning chain
- Don't add closing filler ("Happy to discuss further if needed")

**Handoffs**: Name the person and their role in one phrase. "Dzifa, our business partner, drives that — she'd be the right person to connect with." Not: "That is driven by our business partner, Dzifa."

**Topic pivots**: Use a dash-prefixed label. "On the timeline —" signals a new subject without needing a header.

---

## Anti-Patterns (Never Use)

| My Default | {{YOUR_NAME}}'s Voice |
|---|---|
| Segmented sections | Single flowing paragraph |
| Verbatim block quotes | Paraphrased substance |
| "No action required. I'm monitoring." | "I'll monitor and update you as things progress." |
| Transactional closer | Collaborative, forward-looking closer |
| Pre-announcing a question | Just ask it directly |
| Reasoning chain: "I ask because X and Y" | State the goal only |
| Assumptive framing | Remove. Don't tell the reader what should happen. |
| Closing filler | Cut it. Sign off and move on. |
| "You're the right person to connect with on X" | "You're the expert on X" |

---

## Output

Draft the content directly. No preamble, no explanation of what you're doing. If multiple formats fit, pick the most natural one and note it briefly after the draft.
