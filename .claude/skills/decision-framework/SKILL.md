---
name: decision-framework
description: Structure complex decisions with clear analysis, evaluation of options, risk assessment, and confident recommendations. Use for governance decisions, process changes, vendor selection, resource allocation, and stakeholder conflicts.
user-invocable: true
allowed-tools: Read, Write, Edit
model: sonnet
context: fork
---

## EXECUTE NOW

**Decision: $ARGUMENTS**

If no decision provided, ask: "What decision needs to be made? Include context, constraints, and any options you're already considering."

**Steps:**

1. Identify decision type (Type 1 One-Way Door vs Type 2 Two-Way Door) — see `decision-types.md`
2. Identify RAPID roles for this decision — see `rapid-framework.md`
3. Run 6-step decision analysis — see `procedure.md`
4. Apply risk assessment to top options — see `risk-framework.md`
5. Output decision document using blank template — see `templates/decision-record.md`
6. Draft stakeholder communication — see `templates/communication.md`

Reference `examples/scenarios.md` for Process Change, Stakeholder Conflict, Resource Allocation, and Vendor Selection scenario patterns.

**Output:** see `templates/decision-record.md` (decision document) and `templates/communication.md` (stakeholder message)

**START NOW.** Companion files define the frameworks — use them to structure analysis, not as output to repeat.
