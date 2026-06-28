# Prism eval fixtures

Ground-truth fixtures for `/prism-eval` — the proof harness that measures whether Prism's fleet
actually beats a single careful pass. These are the answer keys; the harness scores against them.

| Fixture | Measures | Key |
|---|---|---|
| `sample-app/payment.ts` + `grounding-key.md` | **Grounding precision/recall** (W3) — does the verifier confirm true claims and strike false/stale ones? | `grounding-key.md` |
| `flaw-detection/*.flawed.ts` + `flaw-detection-key.md` | **Injected-flaw detection** (W4-B) — does fleet vs single-pass catch a planted bug? | `flaw-detection-key.md` |
| `ab-tasks.md` | **Fleet-vs-single win-rate** (W4-A) — blind preference A/B over a task battery | (judged, no fixed key) |

## How the numbers get real
These fixtures make measurement POSSIBLE and repeatable, but the headline metrics (win-rate,
detection rate, calibrated divergence threshold) only exist once `/prism-eval` is actually RUN —
it's a token-heavy multi-task activity, not a static artifact. The harness reports `NOT RUN` for
anything not yet executed and never fabricates a number.

## To make the eval trustworthy
- Expand `ab-tasks.md` from 10 → ≥25 tasks.
- Add more `flaw-detection/` files covering different flaw classes (off-by-one, missing await,
  reentrancy, unchecked index, auth bypass — only one is present today).
- Re-run after any change to the lenses, the verifier, or the skeptic split, and diff the results.
