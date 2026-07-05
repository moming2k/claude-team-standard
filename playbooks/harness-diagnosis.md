# Harness Diagnosis — Top 3 Failure Modes of This Environment

> Written 2026-07-04 by a Fable 5 session, from direct inspection of the
> original author's `~/.claude/` (Claude Code 2.1.201). This file explains WHY
> the rules in `~/.claude/CLAUDE.md` and `~/.claude/rules/common/` exist. Read
> it when a rule seems arbitrary, or before proposing changes to the
> always-loaded files. The "observed" symptoms below are from the original
> machine — treat them as worked examples; your plugin/hook inventory will
> differ, the failure modes won't.

## How this environment loads context (verified 2026-07-04)

- `~/.claude/CLAUDE.md` + every `~/.claude/rules/**/*.md` WITHOUT a `paths:`
  frontmatter gate is injected into EVERY session, every project.
- Files in `~/.claude/rules/<language>/` have `paths:` frontmatter → loaded only
  when matching files exist in the project.
- Files in `~/.claude/playbooks/` are NOT auto-loaded. They are read on demand
  when CLAUDE.md routes you to them. This is deliberate: it is the only way to
  keep the always-loaded budget flat.
- Plugin skills (100+) inject their descriptions every session; this is outside
  our control except by disabling plugins.

## Failure mode 1 — Always-loaded context that is stale or contradicts reality

**Symptom (observed):** Before the 2026-07-04 rewrite, always-loaded rules
mandated tools that were not installed (Context7 MCP, Exa MCP — `mcpServers`
is `{}`), named "Sonnet 4.6 / Opus 4.6" as the newest models (they weren't),
referenced a `TodoWrite` tool that no longer exists under that name, and said
"no custom agents installed" while another file listed 28. A smaller model
follows written instructions literally: it will burn turns trying to call a
nonexistent MCP, route work to a wrong model name, or silently pick one side
of a contradiction.

**Cost:** wasted tool calls, wrong routing, and worst: the model learns to
ignore ALL instructions because some are visibly wrong.

**Fix a weak model can execute:**
1. If an instruction names a tool/MCP/skill you cannot find (check the skills
   list in context, or ToolSearch for tools), do NOT improvise a workaround.
   Skip it, state in your reply "instruction references unavailable tool X",
   and append one line to `~/.claude/playbooks/lessons.md`.
2. Never write a model name or version into any `~/.claude` file without a
   `(verified YYYY-MM-DD, source)` tag. Copy current model IDs only from
   `rules/common/delegation.md`.
3. Do not add content to CLAUDE.md or `rules/common/` — propose additions in
   `lessons.md` instead. Budgets: CLAUDE.md ≤150 lines; all always-loaded
   `rules/common/*.md` combined ≤500 lines. See `playbooks/maintenance.md`.

## Failure mode 2 — Skill sprawl → wrong tool for the intent

**Symptom (observed):** Four overlapping workflow stacks are installed
(gstack, superpowers, gsd, ECC): 4+ planning skills, 5+ review skills, 60+
`gsd:*` commands. The superpowers plugin injects "if there is a 1% chance a
skill applies you MUST invoke it" every session. A smaller model facing this
either over-triggers skills on trivial tasks, nests process skills inside
each other, or picks a different planner each time and loses continuity.

**Fix a weak model can execute:**
1. Use the routing table in `~/.claude/CLAUDE.md`. One intent → one canonical
   skill. If a skill is not in that table, use it only when the user types it
   explicitly (`/whatever`).
2. Maximum ONE process skill (plan/tdd/investigate/qa) active per task. Finish
   or abandon it before starting another.
3. The superpowers "1% chance → MUST" rule is overridden by the CLAUDE.md
   routing table (user instructions outrank skill instructions). Trivial tasks
   (single-file fix, question answering, typo) need no skill at all.

## Failure mode 3 — Doing bulk work in the main conversation

**Symptom (observed):** The Agent (subagent) tool was disabled in settings
until 2026-07-04, so every session did all reading, scanning, and verification
in the main context. Main-context tokens are the most expensive attention
budget: long file dumps push earlier instructions out of effective focus, and
self-review in the same context inherits the same blind spots.

**Fix a weak model can execute:**
1. Follow `rules/common/delegation.md`: any task expected to read more than
   ~3 files or ~200 lines, or any mechanical batch edit, goes to a subagent
   (cheapest model that can do it). Main conversation receives conclusions +
   `file:line` references only.
2. Never verify your own work in the same context. Verification = fresh
   subagent, or a real run (tests, build, curl), or `claude -p` (see
   delegation.md fallback).
3. When a tool result is long, extract what you need and move on; do not quote
   long output back to the user.

## Known but unfixed (user decisions, do not change silently)

- Hook latency: 4 observability integrations (vibecraft, vibe-island,
  pixel-agents, ccani) run on every tool call, some with 5s timeouts. Costs
  latency, not tokens. Removing them is the USER's call.
- `skipDangerousModePermissionPrompt: true` is optional — use with care: it
  removes the dangerous-command safety prompt. If it's enabled, pair
  autonomous work with guardrails (`/careful` or `/guard` before risky
  operations) as the compensating control. Don't flip the setting yourself
  in either direction (settings.json edits need explicit user approval, per
  maintenance.md).
- `~/.claude/rules/<language>/` dirs (11 languages × 5 files) load into any
  matching project; content partially duplicates `rules/common/`. Pruning is
  a maintenance-session candidate (see maintenance.md), not a mid-task edit.
- `~/.claude/AGENTS.md` (read by Codex/OpenCode harnesses, not Claude Code)
  is stale — it advertises 28 ECC agents; the actual `agents.disabled/` dir
  holds 36 entries. Neither number matches anything live.
