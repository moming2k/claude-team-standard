# Maintenance Protocol for ~/.claude

> On-demand file. Read BEFORE editing anything under `~/.claude/`.
> System established 2026-07-04 (team standard). Before installing this
> standard over an existing config, back up your originals under
> `~/.claude/backups/` first.

## Who may edit what

| Path | Any session may edit | Rule |
|---|---|---|
| `playbooks/lessons.md` | YES — append only | Use the lesson format below |
| `~/.claude/projects/*/memory/` | YES | Per the memory system's own rules |
| `playbooks/*.md` (other) | Only to fix a factually wrong statement | Backup first; note the change in lessons.md |
| `CLAUDE.md`, `rules/common/*.md` | NO — propose in lessons.md, user approves | These are always-loaded; every line taxes every future session |
| `settings.json` (hooks, permissions, model) | NO — explicit user approval per change | Backup first, always |
| `rules/<language>/` dirs | NO — flagged for a future pruning session | Their `../common/<old-file>.md` links are historical; `core.md` is now the common layer |
| `AGENTS.md` (Codex/OpenCode harnesses) | NO | Known stale; user decision |

Backup rule for ANY permitted edit outside lessons/memory:
`cp <file> ~/.claude/backups/<file>.$(date +%Y%m%dT%H%M%S)` first.

## Lesson write-back format (`playbooks/lessons.md`)

Append one entry per lesson, newest last:

```
## YYYY-MM-DD <short title>
- Trigger: <what happened — 1-2 lines, concrete>
- Lesson: <what to do differently, stated as an executable rule>
- Proposed rule change: <none | exact edit to which file, for user approval>
```

Write a lesson when: an instruction referenced something nonexistent; a retry
loop was cut by the 2-round limit; an escalation succeeded/failed; the user
corrected the same behavior twice. Do NOT log routine task outcomes (that's
what git history and memory are for).

## Line budgets (hard limits — check with `wc -l` after edits)

- `CLAUDE.md` ≤ 150 lines, index/router only, no long content.
- `CLAUDE.md` + all always-loaded `rules/common/*.md` combined ≤ 650 lines
  (as of 2026-07-04: 222 — headroom is intentional, don't spend it casually).
- `lessons.md` > 150 lines → time for a compaction session (below).

## Compaction session (user-initiated, ~monthly or when budgets trip)

Full runbook incl. the team-sharing step: `playbooks/knowledge-loop.md`.
In brief:

1. Read `lessons.md`; cluster recurring lessons.
2. Promote stable, recurring lessons into the appropriate playbook (or, rarely
   and with user approval, into `rules/common/`); delete promoted + stale
   entries from lessons.md.
3. Re-verify all `(verified YYYY-MM-DD)` claims older than ~2 months:
   model IDs, tool names, skill names, Claude Code behaviors. Update tags.
4. Run the read-back + adversarial review (delegation-templates.md §5) on any
   file changed.
5. Check budgets with `wc -l`.
6. Share: sanitize promoted lessons and open a PR to the team repo
   (checklist and PR procedure in `knowledge-loop.md`).

## Staleness markers

Any factual claim about the environment (model IDs, tool schemas, CLI
behavior) must carry `(verified YYYY-MM-DD)`. If you rely on such a claim and
it fails (e.g. model ID rejected), do not guess a replacement: check the
current environment (`/model`, ToolSearch, `claude --version`), use what you
find, and log a lesson proposing the update.
