# Claude Code Team Standard

A shared `~/.claude/` configuration for Claude Code, extracted from the
"institution" built on 2026-07-04 with Fable 5. The design goal: a weak model
following these files should behave like a disciplined senior engineer —
the system carries the judgment, not the model.

## Design in one paragraph

`CLAUDE.md` is a small ROUTER, always loaded, that points to everything else
by trigger. Two rules files (`rules/common/`) are also always loaded and hold
only universal defaults. Everything long-form lives in `playbooks/`, which is
NEVER auto-loaded — sessions read a playbook only when the router's trigger
table says so. This keeps the always-loaded context flat (hard budget: router
≤150 lines, router + rules combined ≤650) so instructions stay in the model's
effective attention. Mistakes are logged to `lessons.md` and periodically
promoted into playbooks ("compaction"), so the system improves without the
always-loaded files growing.

## What's in the box

| File | Loaded | Purpose |
|---|---|---|
| `CLAUDE.md` | always | Router: playbook triggers, workflow→skill table, hard rules |
| `rules/common/core.md` | always | Engineering defaults: shell tools, style, testing triggers, security, git |
| `rules/common/delegation.md` | always | Subagent dispatch: model ladder, handoff/report contracts, escalation |
| `playbooks/judgment.md` | on demand | Rubrics: when to escalate / declare done / ask the user / change approach |
| `playbooks/delegation-templates.md` | on demand | Fill-in prompt templates for delegating to subagents |
| `playbooks/maintenance.md` | on demand | Who may edit what, backup rule, line budgets, compaction procedure |
| `playbooks/harness-diagnosis.md` | on demand | WHY these rules exist (the failure modes they prevent) |
| `playbooks/letter-to-future-sessions.md` | on demand | Degradation modes + honest confidence report from the authoring session |
| `playbooks/lessons.md` | on demand | Empty template — YOUR machine's append-only mistake log |

## Install

1. Back up what you have: `cp -r ~/.claude/CLAUDE.md ~/.claude/rules ~/.claude/playbooks ~/.claude/backups/pre-standard-$(date +%Y%m%d)/ 2>/dev/null`
2. Copy this folder's contents into `~/.claude/` (creates/overwrites
   `CLAUDE.md`, `rules/common/`, `playbooks/`).
3. Restart Claude Code (always-loaded files are read at session start).
4. Sanity check in a new session: ask "which playbook applies before touching
   config?" — it should cite `maintenance.md`.

## What YOU must adapt (do this once, on install)

- **Workflow routing table in `CLAUDE.md`**: it maps intents to the gstack
  skill suite (`/tdd`, `/investigate`, `/ship`, …) plus a placeholder deploy
  row. Keep only rows whose skills exist in YOUR session's skill list; delete
  or replace the rest (point the deploy row at your own deploy skill). The
  table itself (one intent → one skill, max one process skill per task) is
  the standard; the specific skills are not.
- **Model IDs in `rules/common/delegation.md`**: verified 2026-07-04 on
  Claude Code 2.1.201. If a model ID is rejected, check your live environment
  and update the table — never guess (see `maintenance.md` staleness rules).
- **`lessons.md` starts empty on purpose** — it's per-machine history, not
  shared. Same for Claude's memory directory.
- **NOT included, by design**: `settings.json` (permissions/hooks are personal
  and security-sensitive — never copy another machine's), plugin installs,
  and `rules/<language>/` dirs (the original set was flagged stale/redundant
  with `core.md`; add language rules only if you need them, with `paths:`
  frontmatter so they don't load globally).

## Living with it

- Something bit you (broken assumption, wasted retry loop, user correction)
  → append one entry to `playbooks/lessons.md` in the format from
  `maintenance.md`. This loop is what makes the system compound.
- Never add rules directly to `CLAUDE.md` / `rules/common/` mid-task —
  propose in `lessons.md`, promote during a compaction session (~monthly).
- Every factual claim about the environment carries `(verified YYYY-MM-DD)`;
  re-verify anything older than ~2 months.
