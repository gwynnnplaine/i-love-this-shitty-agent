---
name: type-review
description: Score an existing change's type system 0–5 and label it fast or lasts, using the type-design lens. Use when reviewing a diff or PR for type quality, not when designing types from scratch.
---

Score the change's type system; don't redesign it. Apply the `type-design` lens to the code that's actually there, then rate it. One verdict, with the deciding evidence — not a re-derivation of the whole design.

## Lens

Judge against the `type-design` "Challenge the types" checklist ([../type-design/SKILL.md](../type-design/SKILL.md)):

- Can invalid states be represented? Are they narrowed out?
- Stringly-typed fields that should be unions or branded types?
- Is the interface **deep** (simple surface, hidden complexity) or **shallow** (interface as complex as the impl)?
- Are the **seams** between modules well-typed, or do types leak across boundaries?
- Do the signatures reveal the data flow, or hide it? Delete the bodies — do the types still tell the story?
- Can the interface be tested at the boundary, without mocking internals?

## Score

Rate **0–5**, then label **fast** or **lasts** (lasts is the goal). One sentence each, with the deciding evidence.

- **0–1**: invalid states freely representable, stringly-typed fields, types leak across seams.
- **2–3**: typed but defensive — `??` / `||` / `?.` papering over states that shouldn't exist, shallow interfaces.
- **4–5**: invalid states unrepresentable, deep narrow interface, well-typed seams; delete the bodies and the types still tell the story.
- **fast** = solves today, needs rework when requirements shift. **lasts** = absorbs likely change without API churn.

ALWAYS show the deciding evidence as code, not just prose — a `now / could be / why it lasts` block. For a low score, `now` is the weak type and `could be` is the union/branded/narrowed type you'd write instead. For a 4–5, show the winning construct that earns the score (`now` is the construct, `could be` omitted). `why it lasts` is one sentence on the change it absorbs or the invalid state it kills.

```ts
// now
interface PaymentMethodConfig { method: string }        // any string routes anywhere
// could be
interface PaymentMethodConfig { method: PaymentMethod }  // PaymentMethod = 'card' | 'braintree'
// why it lasts: a new funding source is a compile error at every call site, not a silent misroute.
```

## Seam diagram

When the change touches DI, composition, or adapter/seam wiring, draw the `type-design` single-ASCII seam diagram ([../type-design/SKILL.md](../type-design/SKILL.md)): prod and test paths split only above a `===== SEAM` line and merge into one shared core below. Divergence deeper than the adapter boundary is a finding — the core can't be tested without reaching past the seam.
