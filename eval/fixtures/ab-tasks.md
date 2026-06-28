# Fleet-vs-single A/B task battery (W4-A)

Each task is run twice — full-fleet vs single-careful-pass — then blind-judged. A meaningful
result needs **≥25 tasks**; below is a STARTER set of 10. Expand it before trusting the win-rate.
Pick tasks with real trade-offs (no single obvious answer) so the fleet has something to earn.

## Architecture / design (where deliberation should help most)
1. Should a payments app store an internal balance ledger, or settle every charge on-chain directly?
2. Choose: optimistic UI updates vs server-confirmed updates for a transfer flow. Justify.
3. Design retry/idempotency for a webhook that triggers money movement.
4. Pick a caching strategy for a read-heavy pricing endpoint with occasional invalidation.
5. Multi-tenant data isolation: row-level security vs separate schemas vs separate DBs — choose.

## Debugging / analysis
6. A balance occasionally goes negative under load. Propose the most likely root causes, ranked.
7. p99 latency spikes only during deploys. Diagnose and propose fixes.

## Trade-off calls (subjective, judged on reasoning quality)
8. Adopt a new privacy SDK now (testnet) or wait for mainnet? Frame the decision.
9. Monorepo vs polyrepo for a 3-service product with one small team.
10. Build a feature flag system in-house vs adopt a vendor — for an early-stage team.

## Notes for the runner
- Single-pass = ONE strong Opus prompt, no fan-out, told to be careful and thorough.
- Fleet = the normal Prism deliberation at the config under test.
- Strip labels, randomize A/B order per task, judge with Sonnet (+ a separate Opus); require
  agreement or average. Record per-task: winner, judge agreement, token-multiple.
