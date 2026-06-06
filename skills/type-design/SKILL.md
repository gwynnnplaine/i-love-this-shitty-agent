---
name: type-design
description: Turn resolved design decisions into a type system — type signatures, seams, errors, a disambiguation ledger, and a prod/test call graph — before any implementation. Use after grilling/disambiguation converges, or whenever a plan must become types first.
---

Types are the actual program. Implementation is a runtime courtesy.

Use this once the design decisions are settled — from a grilling session, a spec, `CONTEXT.md` + ADRs, or a handed-off decisions file. Input: the resolved facts. Output: the type-level contracts and call graph the implementer works from.

If a detail can be answered by exploring the codebase (existing names, seams, conventions), explore instead of guessing.

## What to produce

Present the solution as type-level contracts — the public API surface with no function bodies. The types should tell the structural story of the design: data shapes, function signatures, error cases, and state transitions.

No implementation. No function bodies.
Explain design decisions embedded in the type choices.

## Challenge the types

Before asking for approval, stress-test your own type design:

- Can invalid states be represented? Narrow them out.
- Are there stringly-typed fields that should be unions or branded types?
- Is the interface **deep** — simple surface hiding complexity — or **shallow** (interface as complex as the implementation)?
- Are the **seams** between modules well-typed, or do types leak across boundaries?
- Do the function signatures reveal the data flow, or hide it?
- Delete the function bodies mentally — do the types still tell the story?
- Can this interface be tested at the boundary without mocking internals?
- What do these types NOT capture? Invariants that need a runtime assertion (state them as contracts), and behavior over time — accumulation, feedback, delays. Grill those separately; don't let the types pretend they cover the dynamics.

If challenging the types reveals missing constraints, pause and grill until shared understanding before finalizing.

## If you know it, the types should know it

Before the call graph, do one disambiguation pass. List every rule you know about the domain — from the grilling, the ticket, any prose docs. For each fact, pick one:

- **Encode it.** The fact becomes structure: a union member, a branded type, a non-optional field, a narrowed input. "Only a pending invite can be accepted" -> `acceptInvite(invite: PendingInvite)`, not a runtime `if (status !== "pending")`. Distinct states are distinct types in a union, not a `status` string plus optional fields.
- **Contract it.** The type genuinely can't carry it (an invariant across calls, an ordering, a numeric range). State it as an explicit runtime contract and name where it's enforced. When TypeScript can't express the shape itself, reach for a runtime validator (zod, arktype, Effect Schema) — the schema *is* the contract, and its inferred type feeds back into the design.

**ALWAYS validate at the boundary, trust internally.** External/untrusted data (HTTP bodies, env, DB rows, JSON) is decoded by a runtime schema before it becomes a branded or encoded type — that decode is the only place a raw `string` earns the right to be a `WorkspaceId`. Inside the boundary, the types are trusted; no re-checking.

A known fact with no home — neither encoded nor contracted — is an unresolved ambiguity. Surface it and resolve it before finalizing. Prose lets ambiguity hide; types force it into the open.

Output the pass as a visible ledger, not just a mental check:

- **Resolved** — each rule -> the type decision it forced, traceable to its source:
  `"only pending can be accepted" -> acceptInvite(invite: PendingInvite)`.
  Every type choice points back to a sentence.
- **Unresolved** — facts with no home yet, as open questions:
  `is an expired invite still "pending"?`, `what errors can acceptInvite return?`.
  These block finalizing; resolve or grill each before the call graph.

## Then the call graph

Types give the shape and the seams. They do not give the flow. After the types converge, sketch the call graph — the second artifact, and the one you hand to the implementer.

Produce two graphs from the same tree:

- **Production**: handlers -> service -> real adapters -> store/IO.
- **Test**: the same core, fakes/memory adapters swapped in at the seam.

The graphs MUST converge below the seam. If prod and test paths diverge deeper than the adapter boundary, the seam is in the wrong place — the core can't be tested without reaching past it. That divergence point is the proof your seams are real.

Annotate non-obvious ordering and compensation inline, e.g. `createAlias -> store.insert -> index.put -> on index failure: store.delete`. Ordering and rollback are flow facts the types can't carry.

## Gate

Wait for explicit approval of the type signatures before writing any implementation code.

If you produced these as a subagent, do NOT gate yourself: return the type contracts, the ledger (Resolved/Unresolved), and the call graph. The approving session holds the gate. A new ambiguity found while designing goes into **Unresolved** and is returned — never guessed.
