---
description: Close the loop — compare what a prism plan PREDICTED against what actually shipped, then write the lessons back into project memory so future runs are smarter. This is what makes prism learn.
allowed-tools: Task, Read, Grep, Glob, Bash, Write
---
# Prism · Retro: $ARGUMENTS

You are the ORCHESTRATOR running a post-implementation retrospective. The point is not to
re-plan — it's to find the GAP between what prism predicted and what reality did, and bank
the lesson so the next plan starts smarter. Be honest; a retro that finds nothing wrong is
usually a retro that didn't look hard enough.

## Inputs
- Which plan to review: a `docs/NN-*.md` plan and/or the relevant Decision-log entry in
  `.prism/project-model.md`. If the user named one, use it; otherwise pick the most recent
  plan and confirm.
- What actually happened: the real diff/code. Use git (`Bash`: `git log`, `git diff`) and
  Read/Grep the implementation that shipped.

## Steps
1. **Extract predictions.** From the plan, pull its explicit claims: the recommendation, the
   assumptions, the falsifiers ("what would change the answer"), the predicted risks, and the
   open questions it left for the human.
2. **Observe reality (parallel).** FAN-OUT agents to gather what actually shipped: the code
   that got written (`file:line`), what diverged from the plan, what broke or had to be
   reworked, and whether any falsifier actually triggered.
3. **Judge the gap.** For each prediction, mark: CONFIRMED (predicted right), MISSED (a
   problem the plan didn't foresee), or WRONG (the plan asserted something reality disproved).
   For every MISSED/WRONG, find the ROOT CAUSE — which lens should have caught it? what
   assumption was unsafe? was an invariant violated?
4. **Consume the telemetry (W6 — make lessons MEASURED, not anecdotal).** Read the plan's
   `## Telemetry` block. Cross-reference it with what actually happened:
   - Did the bug that shipped come from a `cross-tier-survived` claim (skeptics passed it) rather
     than a `grounded` one? That's evidence cross-tier survival is weak — reinforce grounding.
   - Was the run's divergence score LOW *and* the outcome poor? That's a data point that the fleet
     was cosmetic on this task — feed it to the `/prism-eval` threshold calibration.
   - Was a high-divergence run worth its token-multiple? Note it for the find-the-floor sweep.
5. **Bank the lessons.** Append to the **Lessons** section of `.prism/project-model.md`
   (create if missing), dated. Each lesson: what we predicted, what happened, the root cause,
   the CONCRETE adjustment for next time, AND the measured signal behind it (divergence, claim
   survival mode, token-multiple) — not just narrative. Correct any now-false invariant/danger-zone.

## Output
- A short scorecard: N predictions → X confirmed / Y missed / Z wrong.
- The 2–3 highest-value lessons, plainly stated.
- Exactly what changed in `.prism/project-model.md` (so the next run inherits it).
- If the plan held up well, say so — that's a real signal the process is calibrated.
