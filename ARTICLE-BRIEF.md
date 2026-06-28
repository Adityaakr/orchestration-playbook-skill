# Write an article about Prism

**INSTRUCTION FOR THE ASSISTANT:** Using the two source documents in this repo as your material,
write a polished ~1,500–2,200 word technical article about **Prism**. Read both before writing:

1. [`OVERVIEW.md`](OVERVIEW.md) — what Prism is, the philosophy, the nine commands, the
   deliberation engine (differential context → divergence → judge → cross-tier verify → loop →
   telemetry), project memory, enforcement hooks, the proof harness, a worked example, and honest
   limitations.
2. [`EVAL-REPORT.md`](EVAL-REPORT.md) — the measured result: a 12-task fleet-vs-single evaluation.

## Requirements
- **Lead with the tension, not the features.** The hook: most "multi-agent" tools assert that more
  agents = better answers; Prism is the rare one that *measured its own bet* — and the measurement
  was humbling. Open there.
- Include a dedicated **Architecture** section. Reproduce the architecture diagram as **Mermaid**
  (from `README.md`) and mention the editable hand-drawn `architecture.excalidraw`.
- Include an **Evidence** section built from `EVAL-REPORT.md`: the 12-task result (single beat the
  8-lens fleet 5–3 / 4 ties at ~4.6× cost), the finding that the fleet's edge is *defect-finding*
  not general quality, and the honest confounds. Reproduce the results pie + methodology flowchart
  as Mermaid.
- Cover: the problem, the seven principles, the nine commands, the deliberation engine, project
  memory, the enforcement hooks (hard rules, not prompts), the cross-tier honesty (cross-tier ≠
  cross-model; grounding outranks), the worked example, and the honest limitations.
- **Tone:** technical but readable, for engineers evaluating AI agent tooling. Confident, not hypey.
  The credibility comes from the harness being willing to say "shrink the default."
- **Do not invent features or numbers.** Use only what's in the two source docs. Keep every
  caveat — the honesty *is* the story.

## Suggested structure
1. Hook — the unproven bet, and that Prism tested it.
2. The problem a single LLM pass has (anchoring, averaging, hallucination, statelessness, unenforced safety, unfalsifiable value).
3. Architecture — router → lifecycle → deliberation engine → memory → hooks → proof harness (with the Mermaid diagram).
4. What makes it different — stateful, grounded, self-improving, enforced, **falsifiable**.
5. Evidence — the 12-task eval, the headline, the defect-finding pattern, the confounds (with the Mermaid pie/flow).
6. Honest limitations + what it means: shrink the default, reserve the fleet for review/defect-finding.
7. Close — a harness whose best feature is that it can recommend its own reduction.
