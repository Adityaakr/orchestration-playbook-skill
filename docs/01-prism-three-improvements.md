# Plan 01: Three Prism improvements (big codebases, clean code, /prism-write)

*Decision doc. Produced by `/prism-plan` on 2026-06-30. Grounded in the command files + eval battery.*
*Voice note: written without em-dashes, per the user's standing preference.*

## Recommendation (lead)

Ship three changes, smallest-risk first, as **three separate units** rather than one bundle:

1. **`/prism-write` (new command)** first. It is a new file with zero blast radius on existing flows.
   Scope it to **human-facing prose artifacts**: README, a clean self-contained **HTML article** about
   the built project, and an optional **change summary**. Cohesion principle: same audience (humans
   reading, not the model) plus same discipline (grounded + anti-slop voice). The article mode is the
   genuinely new capability; it delegates visual style to `brand.md` when present and falls back to a
   JetBrains-style default.

2. **Clean-code "Craft floor"** second. A short prose standard added to `prism-build` / `prism-implement`
   / `prism-ship`, subordinate to the existing "conform to the codebase" rule. **No gate heuristics, no
   numeric line cap.** It covers only what lint cannot: intent-revealing names, no dead code, comments
   that explain WHY, and "leave the file at least as readable as you found it."

3. **Big-codebase capability** last, as its own mini-roadmap. It closes two already-open eval tasks
   (Task 5 concern-map staleness, Task 10 monorepo). Cache **structure only**, treat the cache as a
   **navigation hint and never an authority**, validate staleness with **git blob OIDs** (not file-count),
   and let relevance ranking allocate **depth, never inclusion**.

Each was hardened by a cross-tier skeptic pass. Features 1 and 3-of-3 changed materially because of it
(see CHANGELOG). That is the harness working as designed: the fleet earned its cost on defect-finding,
which is the one place the eval says it does (`EVAL-REPORT.md:84-100`).

---

## Feature 1: Work across bigger codebases

**The gap (grounded).** Prism is architecture-aware but scale-blind. The whole scoping algorithm is one
line of prose: "break the target into N parts ... ~3-6 explorers; scale to system size"
(`commands/prism-understand.md:16-21`). The "file-concern map" that W1 differential context depends on is
*specified but unimplemented* (`commands/prism.md:65-67`). There is no persistent index, no monorepo
architecture detection (only a one-line `nearest-manifest-wins` stub at `commands/prism-ship.md:65`), and
the eval battery already logs the two hard parts as OPEN: concern-map staleness (`eval/battery/battery.md:13`,
Task 5) and a TS+Rust monorepo (`eval/battery/battery.md:18`, Task 10).

**Design (post-skeptic).**

- **Repo Map = cached STRUCTURE only.** A `.prism/repo-map.md` (or a section in project-model) holding:
  directory tree, workspace/manifest roots, file inventory, and cheap path/import-derived concern tags
  marked *low-confidence*. It is a **navigation hint, never an authority.** Explorers still independently
  grep/read their slice; the map may be wrong and lenses are told so. No code *claim* is ever grounded on
  the map alone.
- **Staleness via git blob OIDs, not file-count.** `git ls-files` plus per-file blob OIDs is cheap and
  exact on large repos. File-count + a coarse hash is trivially defeated (move a function between two
  equal-size files and the count is unchanged). `/prism-prune` re-checks OIDs and re-buckets on drift.
- **Sizing gate in SCOPE.** Gate the exploration strategy on real file count:
  - small (< ~150 files): current flat 3-6 explorers, unchanged.
  - medium (~150-800): concern-bucketed explorers using the map as a hint.
  - large / monorepo (> ~800): map the structure cheaply first (dirs + manifests, which IS reliable from
    filenames), then explore.
- **Relevance ranking allocates DEPTH, not INCLUSION.** For a TARGETED task (implement slice X, "how does Y
  work") it may concentrate deep reads on the relevant slice, but it always reports what was NOT read. For
  UNDERSTAND / AUDIT / FEEDBACK, every top-level area gets at least a shallow sweep, so a cross-cutting bug
  in the deprioritized 90% is not excluded by construction. This is the key correction: you cannot rank
  what you have not read, so ranking must never be the thing that decides whether code is read at all.
- **Monorepo mode (closes Task 10).** Detect workspaces (`pnpm-workspace.yaml`, `rush.json`, multiple
  `Cargo.toml` / `package.json`), set per-package scope roots, nearest-manifest-wins stack detection per
  package. Structure detection is filename-reliable, so this part is safe and high value. A router flag
  (`commands/prism.md:20-40`) sets "monorepo mode" before understand/plan/build run.

**Touches:** `prism-understand.md:16` (sizing gate + map build), `prism.md:54-67` (implement the bucketing
scan as a hint + router monorepo flag), `prism-prune.md` (OID staleness), `prism-build.md` / `prism-implement.md`
(per-package detect), the project-model template (new Repo Map section).

**Net honest win.** Caching *structure* saves re-deriving topology each run. It does NOT save reading code
(a faithful concern map requires reading, so map-building costs about one exploration). The win is real but
modest, and it only appears on repeated runs, which is exactly when OID staleness checking has to be correct.

---

## Feature 2: Best-practices / clean code when building from scratch

**The gap (grounded).** Prism mandates *conformance* (match existing language, framework, naming, lint:
`commands/prism-implement.md:23-35`) and *test integrity* (`hooks/prism-gate.sh:22-35`), but has **zero
positive code-quality standard.** On greenfield there is nothing to conform to, so code can compile, pass
tests, conform structurally, and still be unmaintainable: cryptic names, bloated functions, no rationale
comments, dead code. The integrity gate is a faked-green tripwire only; it checks no quality at all.

**Design (post-skeptic, deliberately small).**

- **A prose "Craft floor", subordinate to "conform first".** Precedence: match the neighbors' structure and
  style FIRST. The craft floor governs only the parts that are yours to name and document, and applies in
  full only when the code is genuinely greenfield (a new file or project with no local exemplar).
- **The floor (what lint cannot enforce):** intent-revealing names (no `tmp`, `data2`, `handleClick2`);
  one job per function (if you cannot name it in one phrase, split it; **no magic line number**); no dead
  code or unused imports; comments explain WHY (decisions, constraints), not WHAT; leave the file at least
  as readable as you found it.
- **Lean on existing machinery for the rest.** Type discipline (no gratuitous `any`) and required doc
  comments are already enforced objectively by the project's `strict` tsconfig + eslint, which the existing
  done-signal ("no new type/lint errors") already covers. Do not restate them as soft prose.
- **NO changes to `prism-gate.sh`.** Its credibility comes from never crying wolf. Heuristic checks
  (function size, unused imports) are language-specific and noisy in a bash/grep script (a Rust `match`,
  JSX tree, or Go table-test legitimately runs long), and two false alarms train users to ignore the gate,
  eroding the secrets/faked-green signal that actually matters.
- **Never refactor the neighbors inline.** Surrounding mess is logged as a recommendation (or a separate
  `/prism-implement` slice), never fixed in the current diff. This preserves "smallest change / no drive-by
  refactor" (`commands/prism-implement.md:52`).
- **The independent skeptic gets a readability check.** The §4 verify step (`prism-implement.md:84-90`)
  adds one question: "would a new maintainer understand this without you explaining it?"

**Touches:** `prism-build.md` (greenfield Phase 2 sets the craft floor + records it as a convention in
memory), `prism-implement.md` (§2 implement, the done-definition at :40-41, self-review at :94-96, Guardrails
at :108-112), `prism-ship.md:62-84` (BUILD LOOP).

---

## Feature 3: `/prism-write` (human docs, no slop)

**The gap (grounded).** No existing command writes user-facing docs. `prism-implement` summarizes a diff
*into memory* (`commands/prism-implement.md:99-102`), not for humans. Nothing produces a README, an article,
or styled output.

**Design (post-skeptic).** A new `commands/prism-write.md` (~90-110 lines, within the 35-115 envelope),
following the canonical skeleton (frontmatter, persona block, seed-from-memory, persist/memory close). Modes
picked from the target, unified by audience + discipline, not by output format:

- **readme:** generate or refresh a README from `.prism/project-model.md` + the real files, so it is grounded.
- **article:** a clean, self-contained **HTML** article about the built project: real sections, a Mermaid
  or inline-SVG architecture diagram, semantic and accessible markup. This is the marquee mode.
- **summary:** a human changelog of what the agents did, grounded in `git diff` + the Decision log. **Reuses**
  `prism-retro`'s git-diff logic rather than reinventing it (skeptic 3 was right that this overlaps).
- **comments (optional retroactive pass):** a documentation pass over existing code (re-read, then comment
  WHY on the public surface and non-obvious logic). Note: the *default* path for comments is the Feature 2
  craft floor, applied while code is written; this mode is only for documenting code that already shipped bare.

**Cross-cutting rules (the actual point of the feature):**

- **Grounded docs.** Every claim about the code is re-derived from real files. A README that claims a
  feature the code lacks is the doc equivalent of a hallucinated API. This is the one mechanism that does
  meaningfully reduce slop, because it forces the prose to track reality.
- **Human voice / anti-slop.** No em-dashes. No "in today's fast-paced world", no "it's worth noting", no
  hype adjectives, no hollow transitions. Short, active, declarative. Match `~/.prism/user.md` tone when
  writing in the user's voice. Honest caveat: anti-slop-by-prompt only reduces frequency, it does not
  eliminate it. Grounding is the stronger lever; the voice rules are secondary.
- **Styling: real default, ask only when it matters.** JetBrains style is the standing default and the
  command proceeds silently with it for readme / summary / comments (they inherit markdown and repo
  conventions, no styling question). ONLY the HTML article asks, ONCE, batched, and only if no `brand.md`
  exists and the user did not already specify colour/font/direction. JetBrains is pre-filled as the default
  answer, so "just go" works. If `brand.md` exists (from the `brand-design` skill), the article reads its
  tokens and does not re-derive style. This resolves the default-vs-ask contradiction the skeptic flagged:
  a default means proceed; the article is the single exception, asked once.

**Touches:** new `commands/prism-write.md`; add the command to the README + OVERVIEW tables (now eleven
commands); no hook changes. Reads project-model + user.md + `brand.md` (if present) + git for grounding.

---

## Steelman of the rejected option (do nothing new; extend existing commands instead)

The strongest case against new surface area: Prism already has eleven moving parts, and the eval says its
value is *unproven*, so adding three more features dilutes focus before the core bet is settled. Inline
comments genuinely belong in `prism-implement` (cheapest to comment while writing), summaries overlap
`prism-retro`, and a README is a thin wrapper over `project-model.md`. Folding everything into existing
commands keeps the surface small.

**Why I still pass.** Two of the three asks are not new surface, they are *missing floors* on existing
surface: Feature 2 is prose added to commands that already run, and Feature 1 implements a capability the
code already promises (the W1 concern map) and already lists as open work (eval Tasks 5, 10). Only Feature 3
is a new command, and the article mode (styled, self-contained HTML artifact) has no home in any existing
command. The de-duplication the steelman wants is already in the plan: comments default to the craft floor,
summary reuses retro. So the plan absorbs the steelman's best point rather than contradicting it.

---

## Assumptions and falsifiers

- **Assumes** `git` is available for OID-based staleness (Feature 1). Falsifier: a non-git project. Fallback:
  degrade to mtime + size per file, flagged as weaker.
- **Assumes** structure detection from filenames/manifests is reliable (Feature 1 monorepo mode). Falsifier:
  a repo with a non-standard layout and no manifests. Fallback: treat as single-stack, flag low confidence.
- **Assumes** the craft floor will not trigger drive-by refactors (Feature 2). Falsifier: `/prism-retro`
  shows diffs inflating after the change. Mitigation: the "never refactor neighbors inline" rule + the diff
  is checked in self-review.
- **Assumes** grounding plus voice rules cut slop enough to satisfy the user (Feature 3). Falsifier: the
  user still flags generated prose as sloppy. Mitigation: treat output as a draft, iterate.

## Open questions for the human (Aditya)

1. **Build order.** Recommend 3 -> 2 -> 1 (lowest risk and most self-contained first; Feature 1 is its own
   mini-roadmap). Confirm or reorder.
2. **Feature 1 scope now.** Full monorepo mode now (closes eval Task 10), or just the structure-cache +
   sizing gate first and monorepo as a follow-up?
3. **Feature 3 comments mode.** OK to keep inline-comments primarily in the Feature 2 craft floor and make
   the standalone "comment existing code" a thin optional mode, or do you want a first-class retroactive
   documentation command?
4. **Gate.** Confirm we do NOT add code-quality heuristics to `prism-gate.sh` (I recommend against, to keep
   its zero-false-positive charter).

## CHANGELOG (what the skeptic loop changed)

- **Feature 1, materially revised.** Skeptic killed "cache the concern map as authority" and "relevance-prune
  the reads." Now: cache structure only as a non-authoritative hint, git-OID staleness (not file-count),
  relevance allocates depth not inclusion, breadth sweep preserved for audits.
- **Feature 2, narrowed.** Skeptic killed the numeric line cap and the `prism-gate.sh` heuristics (noisy,
  language-blind, credibility-eroding) and flagged the conform-vs-craft conflict. Now: qualitative floor,
  no gate changes, explicit precedence + no-inline-refactor rule, type/doc items delegated to lint.
- **Feature 3, de-duplicated.** Skeptic flagged overlap and the default-vs-ask contradiction. Now: summary
  reuses retro, comments default to the craft floor, article delegates to `brand.md`, and "ask" is the single
  article-only exception to a real JetBrains default.
- **Open risk not closed:** anti-slop-by-prompt remains a soft lever (grounding is the hard one); Feature 1's
  net token win is modest and only on repeated runs.

## Telemetry

- divergence: evidence ~0.9 (3 explorers owned disjoint files), conclusion N/A | this was a grounding
  fan-out, not a competing-recommendation deliberation, so the W2 falsifier does not apply
- models: draft=opus · skeptics=2x-opus+1x-sonnet (cross-tier; version axis unavailable)
- claims: "no positive code-quality floor exists" grounded (read prism-implement.md + prism-gate.sh) ·
  "concern map specified-but-unimplemented; Tasks 5/10 open" grounded (prism.md:65-67, battery.md:13,18) ·
  "no command writes user-facing docs" grounded (read all 10 commands)
- fleet: 3 grounding explorers + 3 cross-tier skeptics

> Cross-tier verification reduces instance- and tier-level error correlation but not shared-lineage blind
> spots. Treat cross-tier survival as weaker evidence than grounding.
