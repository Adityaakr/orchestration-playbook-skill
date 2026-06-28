# Eval result — injected-flaw detection (W4-B), first run

**Date:** 2026-06-29 · **Fixture:** `flaw-detection/order-total.flawed.ts` (planted CRITICAL
auth bypass: `user.role = "staff"` assignment instead of `===`). **n = 1 fixture, 1 run/slot.**

## Question
Does the `2× Opus + 1× Sonnet` skeptic split (W5) weaken detection vs `3× Opus`? Is the Sonnet
slot a liability?

## Method
4 blind reviewers (3× Opus, 1× Sonnet via the Task `model` param) reviewed the file cold — no
answer key, no hint a flaw existed. Scored on whether each named the assignment-vs-comparison
auth bypass. Two panels scored from the shared pool: A = {3 Opus}, B = {2 Opus + the Sonnet}.

## Result
| Reviewer | Caught critical auth bypass | Caught mutation side-effect |
|---|---|---|
| Opus #1 | ✅ | ✅ |
| Opus #2 | ✅ | ✅ |
| Opus #3 | ✅ | ✅ |
| Sonnet  | ✅ | ✅ |

- Panel A (3× Opus): **3/3 detected.**
- Panel B (2× Opus + 1× Sonnet): **3/3 detected.**
- No false alarms that contradicted the key (extra input-validation suggestions were legitimate
  defensive feedback, not false bug claims).

## Honest interpretation
- **The Sonnet did NOT weaken detection** — full parity, including the subtle side-effect and the
  exact fix. The "less-capable-model hurts us" hypothesis is **not supported** here.
- **This fixture cannot prove the split is BETTER than 3× Opus** — the flaw was catchable by all,
  so the panels are indistinguishable. Verdict on "does Sonnet earn its slot": **UNPROVEN, not
  disproven.**
- Minor real signal: reviewers diverged on *secondary* findings (severity of the discount/qty
  validation gaps), so the panel is not echoing a single voice.

## Action
Keep the 2:1 split (no evidence it harms; theory favors decorrelation). To actually decide it,
add subtler flaws where Opus sometimes MISSES (missing await, reentrancy, off-by-one in a loop
bound, unchecked array index) and re-run. Only a harder battery can separate the two configs.

**Status of the broader eval:** divergence metric, grounding P/R, fleet-vs-single A/B → NOT RUN.
