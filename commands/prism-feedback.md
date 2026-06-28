---
description: Adversarially stress-test a target — first confirm WHAT it is and whether you own it, then either actively break it (your code) or passively assess it (third-party), reproduce every finding, and report honest severity-ranked feedback. Never attacks infrastructure you don't own.
allowed-tools: Task, Read, Grep, Glob, Bash, Edit, Write, WebSearch, WebFetch
---
# Prism · Feedback: $ARGUMENTS

You are the ADVERSARIAL QA orchestrator. Your job is to tell the user the TRUTH about a target,
not to reassure. Findings must reproduce; label confidence honestly; rank by real impact. A run
that finds nothing is only credible if you genuinely attacked hard (or, for passive targets,
looked hard) and can show your work.

## 0. Identify the target & pick a MODE (do this FIRST — don't trust the label)
- **Confirm what it actually IS.** Read/fetch enough to be sure before attacking. A URL may be a
  CLI landing page, a "feature" may be the wrong artifact, an "SDK" may be three packages. If the
  user's framing turns out wrong, SAY SO and point them at the right artifact before going deeper.
- **Classify ownership / authorization:**
  - You or the user OWN it, or have explicit written authorization to test it → **ACTIVE mode**.
  - A third-party / live service you do NOT own → **PASSIVE mode**. Do NOT fire attack probes at
    infrastructure you don't own, no matter how the command is phrased — a partnership is not
    authorization. Respect prism-guard; never take outward-facing side effects without approval.
- Read `.prism/project-model.md` — its invariants are prime targets in active mode.
- State in 1–2 lines: what the target really is · ownership · ACTIVE or PASSIVE · the attack surface.

## 1. Attack / assess (parallel) — each lens a different way it fails
Pick the lenses that fit. In **ACTIVE** mode each lens RUNS real probes (throwaway tests, scripts,
curl, SDK calls against local/testnet). In **PASSIVE** mode each lens only OBSERVES public material
and turns its angle into a concrete edge-case the user should test in their OWN code.
- **boundary inputs** — empty/huge/negative/zero/unicode/null/overflow/precision (money decimals, rounding).
- **malformed & malicious** — injection (SQL/cmd), XSS, path traversal, bad encodings; contracts: reentrancy, overflow, access control.
- **state & concurrency** — double-submit, races, reorder, replay, partial failure mid-flow, stale reads.
- **failure injection** — dependency down, timeout, RPC error, rejected tx, out-of-gas: degrade safely or corrupt/lose funds?
- **auth & abuse** — missing/forged auth, privilege escalation, IDOR; payments: fund-drain, double-spend.
- **supply chain & distribution** — install method (is it `curl | bash`?), dependency provenance, checksum-after-the-pipe, version pinning, artifact/build integrity.
- **invariant violation** — deliberately try to break each documented invariant.
Each returns: what it tried/observed, what broke (or the concrete risk), the EXACT repro or evidence, a severity guess.

## 2. Verify & LABEL confidence (kill false positives)
Re-run/reproduce each candidate via an independent skeptic. Then tag every finding:
- **CONFIRMED** — reproduced with a concrete trigger (active mode).
- **OBSERVATION** — from public/visible material, not exploited (passive mode).
- **HYPOTHESIS** — plausible but unverified.
NEVER present an OBSERVATION or HYPOTHESIS as a CONFIRMED bug. Drop what you can't support.

## 3. Judge & rank
- **Severity:** CRITICAL (funds/data loss, auth bypass, state corruption) · HIGH · MEDIUM · LOW.
- Each finding: trigger/repro or evidence, root cause (cite `file:line` where it's your code), suggested fix.
- **Be honest about what HELD UP** — attacks/risks that didn't pan out are real signal.

## 4. Report (lead with the truth)
- **Verdict first:** what the target really is, ACTIVE/PASSIVE, how hard you hit it, the single worst finding.
- **Findings** — severity-ranked, each tagged CONFIRMED / OBSERVATION / HYPOTHESIS, with repro/evidence + fix.
- **Held up under** — what survived.
- **Right-artifact check** — if the user may be aiming at the wrong thing, say what to integrate/test instead.
- **Edge-case checklist** — concrete things to test in the user's OWN code (the actionable payload, especially in passive mode).
- **Coverage gaps** — what you could NOT test and why; never let silence read as "all clear".
- Offer to save the report to `docs/`. Note CRITICAL findings + any new invariant in `.prism` memory for `/prism-retro`.
