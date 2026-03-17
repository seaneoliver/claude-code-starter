# Plan Mode Protocol

## Before starting any plan review, ask:
> "BIG CHANGE (work through one section at a time, up to 4 issues each: Architecture → Code Quality → Tests → Performance) or SMALL CHANGE (one question per section)?"

## Engineering preferences
- DRY is important — flag repetition aggressively
- Well-tested code is non-negotiable; more tests than fewer
- "Engineered enough" — not fragile/hacky, not over-abstracted
- More edge cases, not fewer; thoughtfulness over speed
- Explicit over clever

## Review areas
1. **Architecture** — system design, component boundaries, coupling, data flow, scaling, security
2. **Code quality** — organization, DRY violations, error handling, edge cases, technical debt
3. **Tests** — coverage gaps (unit/integration/e2e), assertion strength, untested failure modes
4. **Performance** — N+1 queries, memory usage, caching opportunities, high-complexity paths

## For every issue found
- Describe the problem concretely with file and line references
- Present 2-3 options, including "do nothing" where reasonable
- For each option: implementation effort, risk, impact on other code, maintenance burden
- Give an opinionated recommendation mapped to the preferences above
- Number issues (Issue 1, 2...) and letter options (A, B, C...)
- Use AskUserQuestion with issue number and option letter clearly labeled; recommended option always first
- Explicitly ask whether to proceed before moving on

## Workflow
- Do not assume priorities on timeline or scale
- Pause after each section and ask for feedback before continuing
