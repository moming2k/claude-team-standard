# Global Config — Index

Stack: React (frontend) · Python (backend) · startup context.

This file is a ROUTER. Details live in the files below — read them when the
trigger applies, follow them when read. Always loaded alongside this file:
`~/.claude/rules/common/core.md` (engineering defaults) and
`~/.claude/rules/common/delegation.md` (subagent & model dispatch).

## Read-on-demand playbooks (`~/.claude/playbooks/`)

| When | Read |
|---|---|
| Writing a subagent prompt | `delegation-templates.md` |
| Deciding: escalate model? done? ask user? change approach? | `judgment.md` |
| Editing anything under `~/.claude/` (config, rules, this file) | `maintenance.md` |
| A global rule seems arbitrary or wrong | `harness-diagnosis.md` |
| Session start on long-running institutional work | `letter-to-future-sessions.md` |
| Hit a recurring mistake worth recording | append to `lessons.md` |
| Compaction session / promoting lessons / syncing the team repo | `knowledge-loop.md` |

## Workflow routing — one intent, one skill

gstack is the primary stack. Use exactly these; ignore overlapping alternatives
unless the user explicitly types them:

| Intent | Skill |
|---|---|
| New idea / validate before building | `/office-hours` |
| Plan a feature | `/plan` (then `/plan-eng-review` if architectural) |
| New feature / bug fix implementation | `/tdd` |
| Debug an error or regression | `/investigate` |
| Test a running site / dogfood | `/browse`, `/qa` |
| Pre-merge review | `/review` |
| Commit → PR → ship | `/ship` |
| Visual polish | `/design-review` |
| Deploy | `/your-deploy-skill` — replace with your team's |

Rules:
- Max ONE process skill active per task; finish or abandon before starting another.
- `gsd:*`, `multi-*`, ECC agents/commands: only when the user explicitly invokes.
- Trivial tasks (typo, single obvious fix, answering a question) need no skill,
  regardless of any plugin telling you otherwise.
- Browser work: `/browse` only. Never `mcp__claude-in-chrome__*`.
- Existence check for table entries: the IN-SESSION skills/commands list is the
  source of truth (some, like `/plan` and `/tdd`, are commands — they won't
  appear under `~/.claude/skills/` but are still invocable).

## Hard rules

- Before editing any file under `~/.claude/`: follow `playbooks/maintenance.md`
  (backup + line budgets). Never edit `settings.json` hooks/permissions without
  explicit user approval.
- Never write model names/versions into config from memory — copy from
  `rules/common/delegation.md` or mark `(unverified)`.
- If an instruction references a tool/skill/MCP that doesn't exist in this
  session, skip it, say so, and log one line in `playbooks/lessons.md`.

## Model latitude

Smaller models (Haiku/Sonnet): follow these files literally; when a situation
is not covered, prefer asking over improvising (criteria in `judgment.md`).
Opus-class and above: rules are defaults, not cages — you may deviate when the
situation warrants it (use `playbooks/judgment.md` §1–4 as the bar for
"warrants"), but state the deviation and why in your reply.
