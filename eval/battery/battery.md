# Fleet-vs-single battery — 12 real tasks (Prism's own domain)

Genuine design/architecture/code-decision questions a maintainer or power-user of THIS
codebase would actually ask. Each has real trade-offs and no single obvious answer (so the
fleet has something to earn). Each references real files so grounding/divergence are possible.

| # | Task | Touches |
|---|------|---------|
| 1 | The adversarial skeptic split is fixed at 2×Opus+1×Sonnet. Is that the right ratio for this harness, or should it be 1:1, 3×Opus, or claim-adaptive? Decide with reasoning. | `commands/prism.md` VERIFY |
| 2 | The divergence score weights evidence-overlap 0.6 / conclusion-disagreement 0.4. Defend or revise these weights. | `commands/prism.md` DIVERGENCE |
| 3 | `.prism/project-model.md` grows unbounded as a project ages. Design the concrete policy `/prism-prune` should enforce to keep it trustworthy without losing history. | `commands/prism-prune.md` |
| 4 | When the divergence score is below threshold, should the run abort, warn-and-continue, or auto-add lenses? Choose the behaviour and where it lives. | W2 / `prism.md` |
| 5 | The file-concern map (W1) goes stale as code moves. Design its invalidation strategy so differential routing doesn't silently degrade. | W1 / `prism.md` FAN-OUT |
| 6 | Should `/prism-implement` auto-create a feature branch, or hard-require the user already be on one? Trade safety vs friction. | `commands/prism-implement.md` |
| 7 | `prism-guard` blocks `rm -rf`, but users legitimately need `rm -rf node_modules` often. Resolve this without weakening the one-way-door guarantee. | `hooks/prism-guard.sh` |
| 8 | Telemetry currently lives in the decision doc AND memory. Should it instead be a separate append-only metrics file? Decide the storage model. | W6 / `prism-retro.md` |
| 9 | The refinement loop stops on "no material change" — subjective. Make the convergence test operational and measurable. | `commands/prism.md` LOOP |
| 10 | Stack detection assumes one stack. Design how `/prism-build` and `/prism-implement` handle a monorepo with a TS frontend + Rust contracts. | `prism-build.md` / `prism-implement.md` |
| 11 | The eval's blind judge is a single Sonnet. Trustworthy enough, or should it be dual-judge / panel? Trade rigor vs self-preference vs cost. | `commands/prism-eval.md` W4 |
| 12 | Should `/prism-feedback` ever run active probes against a staging environment (not just local/testnet)? Define the policy and the guardrail. | `commands/prism-feedback.md` ownership branch |

## Why these (not the placeholder `ab-tasks.md` set)
The shipped `ab-tasks.md` is generic (payments/DeFi). These are about *Prism itself* — the
codebase under eval — so lens briefs can cite real files (testing W1/divergence) and the
answers are checkable against the actual harness (less subjective judging).
