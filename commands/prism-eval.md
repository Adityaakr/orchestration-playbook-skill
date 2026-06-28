---
description: Prism's own proof harness — measure whether the fleet actually beats a single careful pass. Reports divergence, grounding precision/recall, fleet-vs-single win-rate, injected-flaw detection, and the minimal config that still wins. Built to be able to say "shrink the default."
allowed-tools: Task, Read, Grep, Glob, Bash, Write
---
# Prism · Eval: $ARGUMENTS

You are running PRISM'S OWN PROOF HARNESS. Prism's core bet — that fanning one base model into
lenses + judging + adversarial verify beats a single careful pass — is UNPROVEN. This command
measures it honestly. It must be willing to report that the fleet does NOT earn its cost.

**Honesty rules (non-negotiable):**
- Report REAL numbers from actual runs against the fixtures. NEVER fabricate a metric. If a
  section wasn't run, label it `NOT RUN` — do not invent results.
- The harness must be able to output **"shrink the default — the smaller config wins."** A proof
  harness that can only ever justify the big fleet is a marketing harness, not a proof.
- Cross-tier ≠ cross-model; grounding outranks cross-tier survival (carry these through reporting).

Fixtures: `eval/fixtures/` (ships with the repo) and/or `.prism/eval/fixtures/` (project-specific).
Read `eval/fixtures/README.md` for the answer keys.

## W3 — Grounding precision / recall (has ground truth)
1. Load fixtures: known-true invariants (with `file:line`) + the injected-violations key (broken
   invariants, stale citations, false `file:line` claims).
2. Run the grounding verifier (VERIFY step a) over the mixed claim set.
3. Score vs the key: `precision = caught_real / (caught_real + false_positives)`;
   `recall = caught_real / all_injected`. Report both with raw counts.

## W4 — Fleet vs single-pass (tests the core claim)
Target tasks have no answer key, so don't grade them directly — use two objective harnesses:
- **A. Blind preference A/B.** For each task in `eval/fixtures/ab-tasks.md` (battery of ≥25):
  produce (1) a full-fleet answer and (2) a single-careful-pass answer (one strong Opus prompt, no
  fan-out). Strip labels, randomize order, and judge with a DIFFERENT tier (Sonnet) and/or a
  separate Opus instance — require agreement or average to cut self-preference. Report **win-rate +
  confidence interval + token-multiple** (fleet tokens ÷ single tokens).
- **B. Injected-flaw detection.** Take the correct artifacts in `eval/fixtures/flaw-detection/`,
  each with ONE planted subtle flaw (real security hole / wrong invariant / off-by-one) per the
  key. Run fleet and single-pass as REVIEWERS; measure detection rate for each. Right answer exists
  → more objective than preference.

## W6 — Find-the-floor (configuration sweep)
Run the W4 battery at three configs: `2-lens + grounding + hooks`, `4-lens`, full `8-lens`. Report
each config's win-rate + injected-flaw detection + token-multiple. Identify the MINIMAL config that
still beats single-pass. You are explicitly ENCOURAGED to recommend shrinking the default if the
bigger fleets don't earn their token-multiple.

## Calibrate the divergence threshold (feeds W2)
From the A/B results, find the divergence level below which fleet win-rate collapses to single-pass.
That number replaces the UNCALIBRATED 0.30 placeholder. Write it to `.prism/eval/threshold.txt`
with the supporting data. Until ≥25 tasks are run, keep it UNCALIBRATED and say how many tasks short.

## Output (REAL numbers, or NOT RUN)
1. Divergence Score (+ components) and the calibrated threshold (or "uncalibrated — N tasks short").
2. Grounding precision/recall (+ raw counts).
3. Fleet-vs-single win-rate (+ CI + token-multiple) and injected-flaw detection rate.
4. Config sweep → the minimal config that beats single-pass, with an explicit recommendation
   (keep 8 / shrink to 6 / shrink to 4 / …).
State clearly which parts were actually RUN vs NOT RUN. Save the report to `eval/results/<date>.md`.
