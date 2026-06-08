---
description: Docs-grounded grilling, then design the type system from the resolved decisions 
argument-hint: "[feature, plan, or domain area to design]"
---
Target: $ARGUMENTS

One session, two movements: grill against the docs, then turn the resolved decisions into types. No subagent, no handoff file — the decisions live in this conversation, and the durable parts land in `CONTEXT.md` and the ADRs.

## Grill against the docs

Use the `grill-with-docs` skill. Grill one question at a time. **Use the structured question tool** (e.g. `ask_user`/`ask`/`user_input`) for every question — never plain text — and put only the question through the tool; context and reasoning stay in the message body. Give your recommended answer with each question. If the codebase can answer a question, explore it instead of asking.

As decisions crystallise:

- sharpen vocabulary into `CONTEXT.md` (glossary only),
- record load-bearing, hard-to-reverse choices as ADRs under `docs/adr/`.

`CONTEXT.md` and the ADRs are the durable payoff — they outlive this session. The plan-level decisions that are neither glossary nor ADR stay in the conversation.

## Design the types

When the grilling converges — questions stop revealing new constraints — design the types in this same session using the `type-design` skill. Use `CONTEXT.md` vocabulary for type and seam names. Produce:

- the type contracts (no bodies),
- the disambiguation ledger as a code block (`// RESOLVED` decisions with the rule as a trailing comment; `// UNRESOLVED` as comment-questions),
- the prod/test call graph as a single ASCII diagram with the converging seam.

A new ambiguity found while designing goes into **UNRESOLVED** — never guessed.

## Gate

Present the types, ledger, and call graph. If **UNRESOLVED** is non-empty, grill those here one at a time (structured question tool), update `CONTEXT.md`/ADRs as needed, then re-run the type pass. Wait for explicit approval of the type signatures before any implementation.
