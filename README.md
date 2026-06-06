# i-love-this-shitty-agent

> personal pi config of someone who got addicted to it (feb 2026)

My config for Pi (`@earendil-works/pi-coding-agent`). Prompts, skills, extensions, and the standards I make every agent follow so it stops embarrassing me. It all gets symlinked into `~/.pi/agent`. Edit the source here, never there. I learned that the hard way.

## Deploy

```bash
./link-to-pi.sh   # symlinks every top-level entry into ~/.pi/agent
```

## What's inside

**Prompts** (`prompts/`): workflow rails, invoked as `/name`.

- `/review`: deep, read-only code review. It traces behavior vertically and has to prove every finding, so no vibes-based nitpicks.
- `/tonight-is-the-night-for-donuts`: grills the domain into docs, then hands off to a subagent that turns the decisions into types. Yes, that is really the name.

**Skills** (`skills/`): methodology the agent loads on demand.

- `grill-with-types` / `grill-with-docs`: stress-test a plan. One in your head, one against the docs.
- `type-design`: the hub. Turns settled decisions into type contracts, a disambiguation ledger, and a prod/test call graph.
- `type-review`: scores a diff's types 0 to 5, fast or lasts.
- `tdd`, `typescript-meta`, `design-patterns`, `grill-me`: the rest of the arsenal, half of which I forget I own.

**Extensions** (`extensions/`): `/context` (what's loaded plus token spend), a desktop ping when the agent finishes and wants me back, and a spinner that talks nonsense.

**The law**: `AGENTS.md` (how to behave), `CODING_STANDARDS.md` (TS/JS), `SYSTEM.md` (Dexter, the persona who pretends this is all very serious).
