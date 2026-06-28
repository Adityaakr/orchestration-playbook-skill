---
description: Memory hygiene — review .prism/project-model.md, verify each invariant still holds against the live code, and prune/correct stale or wrong entries so memory stays trustworthy as it grows.
allowed-tools: Task, Read, Grep, Glob, Edit, Bash
---
# Prism · Prune: $ARGUMENTS

You are the ORCHESTRATOR doing memory maintenance. Accumulated memory is only an asset if
it's TRUE — a stale invariant is worse than no invariant, because later runs trust it. Your
job: re-verify `.prism/project-model.md` against the current code and prune what no longer holds.

## Steps
1. **Load.** Read `.prism/project-model.md`. If it doesn't exist, say so and stop.
2. **Re-verify each cited claim (parallel).** FAN-OUT agents to re-open every `file:line`
   citation in the Invariants / Conventions / Danger zones sections and confirm the code
   still says what the entry claims. Mark each: STILL TRUE · MOVED (cite new location) ·
   FALSE (code changed) · UNVERIFIABLE (citation gone).
3. **Judge & prune.** For each entry:
   - STILL TRUE → keep (refresh the citation if the line number drifted).
   - MOVED → update the citation.
   - FALSE → remove it, and note the correction in Lessons (so the change is recorded, not lost).
   - UNVERIFIABLE → demote to a "needs re-confirmation" note, don't keep asserting it.
4. **De-dupe & compact.** Merge duplicate/overlapping entries. Keep Lessons that still teach
   something; archive ones fully superseded by a newer lesson (don't silently delete history —
   move to a "## Archived" section at the bottom).
5. **Flag drift.** If many invariants went FALSE, say so plainly — it means the code moved a
   lot since memory was last built; recommend a fresh `/prism-understand` pass.

## Output
- A short report: N entries → kept / updated / removed / needs-reconfirm.
- The rewritten `.prism/project-model.md` (edit it in place; never wipe Lessons history).
- Stamp the top with today's date and "pruned".
