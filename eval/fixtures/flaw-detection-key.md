# Flaw-detection eval — answer key (W4-B)

⚠️ Do not read this before running the reviewers. It's the ground truth for scoring.

## `order-total.flawed.ts`
**Planted flaw (CRITICAL — auth bypass):** line 21,
```ts
return user.role = "staff" ? true : false;
```
Uses assignment `=` instead of comparison `===`. The expression `user.role = "staff"` assigns
"staff" (a truthy string) and evaluates truthy, so the ternary ALWAYS returns `true`. Result: any
user — not just staff — can authorize refunds above $100. Correct line should be
`return user.role === "staff";`

**Decoys (NOT flaws — a good reviewer should NOT flag these):**
- `Math.round` on line 16 is acceptable rounding for integer cents.
- `1 - discountPercent / 100` is correct for a 0–100 percentage.

## Scoring
- A reviewer "detects" if it names the line-21 assignment-vs-comparison auth bypass.
- Detection rate = fraction of runs (per config) that catch it.
- Bonus signal: false-alarm rate on the decoys (flagging line 16/12 as bugs).

This fixture is deliberately tiny and single-flaw. Expand `flaw-detection/` with more files
(different flaw classes: off-by-one, missing await, reentrancy, unchecked index) to make the
detection-rate statistically meaningful.
