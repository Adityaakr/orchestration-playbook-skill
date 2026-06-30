---
description: Understand/map existing code or a concept — parallel explorers over each subsystem, synthesized into one coherent model with a file map. Read-only, fast.
allowed-tools: Task, Read, Grep, Glob, WebSearch, WebFetch, Write
---
# Prism · Understand: $ARGUMENTS

**User layer:** before starting, read `~/.prism/user.md` and follow its Persona Protocol — greet
by name once (lightly), match the recorded tone/verbosity/expertise, apply standing defaults, and
bootstrap/capture durable prefs. It's the global USER layer; keep it separate from the per-repo
`.prism/project-model.md` CODE layer.

You are the ORCHESTRATOR. Map the thing, don't guess. Run parallel explorers, then
synthesize ONE coherent model. Lead with a plain-language explanation.

## Steps
0. SIZE & MAP (pre-flight — this picks the strategy; do it before scoping). Measure the repo first:
   - Count source files cheaply (`git ls-files | wc -l`, or `find` excluding deps/build dirs).
   - If `.prism/repo-map.md` exists, check it is still fresh (see "Repo Map" below) and reuse its
     structure instead of re-deriving it.
   Then pick the strategy by size:
   - **Small (< ~150 files):** skip the map. SCOPE and fan out 3–6 flat explorers as before.
   - **Medium (~150–800):** build or refresh the Repo Map, then route explorers by concern bucket.
   - **Large (> ~800) or monorepo:** map the STRUCTURE first (directories + manifest roots, which is
     cheap and reliable from filenames), rank areas by relevance to THIS task, then explore.
1. SCOPE: break the target into N parts (subsystems / files / concepts). State them in one line.
   On a large repo, relevance ranking decides how DEEPLY to read each area, NOT whether to read it:
   for "map/understand" or audit requests, every top-level area still gets at least a shallow sweep,
   so a cross-cutting issue in the deprioritized code is not excluded by construction. For a narrow,
   targeted question you may concentrate the deep reads, but state plainly what you did NOT open.
2. FAN-OUT (parallel, ONE message): launch one explorer subagent per part via Task, each
   with Read/Grep/Glob. Each returns a TIGHT map: what this part does, the key `file:line`
   anchors, and how it connects to the rest. No padding. (Give one agent WebSearch/WebFetch
   if the concept needs current external facts.) Diversity rule: no two explorers cover the
   same ground. Use ~3–6 explorers for a small repo; scale up with size, but cap each explorer's
   scope so its cited `file:line` set stays meaningful (a brief that cites 400 files measures nothing).
3. JUDGE: read all maps, reconcile overlaps/contradictions, and synthesize ONE model:
   - the end-to-end flow (step by step)
   - the data model / key types
   - the seams where you'd extend or change it
4. COMPLETENESS CRITIC: spawn one agent asking "what's missing, unread, or unexplained
   here?" — fold in what it finds.

## Output
- Lead with a PLAIN-LANGUAGE explanation a newcomer could follow.
- Then a FILE MAP table: area → key `file:line` → purpose.
- Then "where to touch it" for the most likely changes.
- Flag anything you could NOT confirm in the code (don't smooth it over).
- PERSIST only if the user asks: save to `docs/` as a new numbered file, never overwrite.

## Project memory (ALWAYS update — this is what makes prism compound)
Write/refine `.prism/project-model.md` at the repo root (create the file + folder if missing).
It is a durable, evidence-cited model of THIS project that every future prism run reads first.
Sections to maintain:
- **Architecture** — the components and how they connect.
- **Invariants** — the rules the code silently relies on (e.g. "amounts are 6-decimal USDC",
  "approve must precede pay"). Each MUST carry a `file:line` citation.
- **Conventions** — naming, patterns, where things live.
- **Danger zones** — code that's fragile, security-sensitive, or easy to break.
- **Decision log** — links to any `docs/NN-*.md` plans.
- **Lessons** — left for `prism-retro`; never delete existing ones.
RULE: every line about the code carries a `file:line` citation. Update IN PLACE — append and
refine, never wipe prior content. Stamp the top with today's date + which command updated it.
Tell the user you updated project memory and what changed.

## Repo Map (the structure cache — a navigation HINT, never an authority)
For medium+ repos, cache the STRUCTURE (not conclusions about the code) in `.prism/repo-map.md` so
later runs skip re-deriving the topology. It holds:
- the directory tree and each top-level area's role, the workspace/manifest roots (`package.json`,
  `Cargo.toml`, `pnpm-workspace.yaml`, `go.mod`, etc.), and a cheap, LOW-CONFIDENCE concern tagging of
  files (security/auth, money-movement, schema/ledger, UI, infra) derived from paths + imports.
- a staleness fingerprint: the git blob OIDs of tracked files (`git ls-files -s`), NOT a file count
  (moving logic between two equal-size files leaves a count unchanged, so a count is not a real signal).
RULES that keep the cache safe:
- The map routes explorers; it is NEVER a source of truth. Lenses still open and grep their own slice,
  and no CLAIM is ever grounded on the map alone. The concern tags are low-confidence by construction.
- Refresh, do not trust blindly: on any drift in the OID fingerprint, re-bucket the changed files
  (`/prism-prune` does this routinely). If git is unavailable, fall back to per-file mtime+size and
  flag it as a weaker signal.
