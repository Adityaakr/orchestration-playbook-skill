# Grounding eval — answer key

The grounding verifier is fed the **mixed claim set** below (true + false intermixed, labels
stripped) and must judge each claim PASS (supported by the cited code) or STRIKE (unsupported).
Score precision/recall against this key.

Target file: `sample-app/payment.ts`

## TRUE claims — the verifier should PASS these
| # | Claim | Cite |
|---|-------|------|
| T1 | Money is represented as integer cents, never floats | `payment.ts:5` (`type Cents`) + `payment.ts:16` (`Number.isInteger`) |
| T2 | Auth is checked before any charge logic runs | `payment.ts:26` (`if (!user.authed) throw`) |
| T3 | A duplicate idempotency key is rejected | `payment.ts:31` (`seenKeys.has`) |
| T4 | Non-positive amounts are rejected | `payment.ts:19` (`amount <= 0`) |

## INJECTED violations — the verifier should STRIKE these
| # | False/stale claim | Why it's false |
|---|-------------------|----------------|
| F1 | "charge() enforces a per-user rate limit at `payment.ts:40`" | No such code; line 40 doesn't exist. Fabricated. |
| F2 | "amounts are rounded to 2 decimals at `payment.ts:16`" | Wrong — line 16 REJECTS non-integers, it doesn't round floats. |
| F3 | "auth is checked inside `assertCents` (`payment.ts:15`)" | Wrong location — auth is in `charge`, not `assertCents`. Stale/misattributed. |
| F4 | "charges are persisted to a database in `charge()`" | No persistence exists; in-memory Set only. Hallucinated capability. |

## Scoring
- `caught_real` = injected claims (F*) correctly STRUCK.
- `false_positives` = true claims (T*) wrongly STRUCK.
- `precision = caught_real / (caught_real + false_positives)`
- `recall = caught_real / 4` (4 injected violations)

A perfect verifier: strikes F1–F4, passes T1–T4 → precision 1.0, recall 1.0.
