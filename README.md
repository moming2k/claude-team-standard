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
| `playbooks/knowledge-loop.md` | on demand | The self-improvement pipeline: capture → compact → share via PR → pull |
| `install.sh` | — | Installer/updater: backs up, copies, never clobbers local `lessons.md` |

## Install / update

1. Clone this repo (keep the clone — updates arrive through `git pull`).
2. Run `./install.sh` — it backs up whatever it replaces into
   `~/.claude/backups/` and copies the standard in. Local `lessons.md` and
   Claude memory are never overwritten, so re-running after a pull is safe.
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

## The self-improvement loop

The system is designed to compound (full protocol: `playbooks/knowledge-loop.md`):

1. **Capture** — something bit a session → one entry in your local
   `playbooks/lessons.md`. Machine-private, append-only, zero ceremony.
2. **Compact** — monthly (or when `lessons.md` >150 lines), run the runbook
   in `knowledge-loop.md` on the strongest model you have: promote recurring
   lessons into playbooks, drop stale ones, re-verify dated claims.
3. **Share** — promoted lessons go to THIS repo as a sanitized PR (the repo
   is public: no names, infra, or security-posture facts — checklist in
   `knowledge-loop.md`). A human teammate reviews and merges.
4. **Pull** — everyone else `git pull` + `./install.sh`. N machines' lessons
   compound into one standard.

Never add rules directly to `CLAUDE.md` / `rules/common/` mid-task — propose
in `lessons.md`; always-loaded files change only through a reviewed PR.
Every factual claim about the environment carries `(verified YYYY-MM-DD)`;
re-verify anything older than ~2 months.

## Operating without Fable

This standard was authored with Fable 5, which has scarce availability —
`rules/common/delegation.md` already says "do not plan around it". The system
is built to run on weaker models: the judgment lives in the files, the model
just needs discipline. When top-model access goes away:

- **Day-to-day**: Sonnet, following the router literally (see "Model
  latitude" in `CLAUDE.md`). Escalate per the delegation ladder; Opus-class
  is the escalation and compaction model, not the daily driver.
- **Move judgment into process**: what Fable did with raw capability, the
  loop does with structure — human PR review gates all shared knowledge
  (Tier 1/2), a fresh adversarial agent reviews every changed file
  (delegation-templates §5), and verification is by execution (tests,
  builds, real runs), never self-review.
- **Compaction cadence matters more, not less**: weaker models generate more
  lessons and worse in-the-moment judgment. The monthly compaction on your
  strongest available model is what converts that noise into standards.
- **Re-verify on lineup changes**: when the model roster shifts, the model
  table in `rules/common/delegation.md` is the first thing to go stale —
  update it from the live environment, never from memory.
