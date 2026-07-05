# Delegation & Model Dispatch

> Always loaded. Prompt templates: `~/.claude/playbooks/delegation-templates.md`.
> Judgment calls (when to escalate / stop / ask): `~/.claude/playbooks/judgment.md`.

## Principle: the commander stays out of the trenches

The main conversation is the most expensive context. Spend it only on decisions
that would lose quality on a cheaper model: architecture, ambiguous tradeoffs,
user communication, and integrating results.

Delegate to a subagent (Agent tool) when a task is:
- reading/scanning more than ~3 files or ~200 lines to answer a question
- repo-wide searches, web research, log digging
- mechanical batch edits across files
- verification of another agent's (or your own) work

Do it yourself in the main thread when it is: a single targeted read/edit,
a decision, or faster to do than to explain.

## Models (verified 2026-07-04, Claude Code 2.1.201 — reverify after upgrades)

Agent tool `model` parameter accepts exactly: `haiku` | `sonnet` | `opus` | `fable`.
The Agent tool has NO per-task effort parameter (global `effortLevel` lives in
settings.json). Full model IDs for `claude -p --model` / API:

| Alias | Full ID | Use for |
|---|---|---|
| `haiku` | `claude-haiku-4-5-20251001` | Bulk reads, scans, format checks, mechanical edits, read-back verification |
| `sonnet` | `claude-sonnet-5` | DEFAULT. Implementation, refactoring, research, reviews |
| `opus` | `claude-opus-4-8` | Escalation target: architecture, ambiguous debugging, adversarial review of high-stakes work |
| `fable` | `claude-fable-5` | Do not plan around it — scarce/limited availability |

Useful `subagent_type` values (verified): `general-purpose` (default),
`Explore` (read-only fan-out search), `Plan` (architecture planning).
If a listed type is missing in a future session, fall back to `general-purpose`.

## Handoff contract — every delegation includes three things

1. **Goal + why**: what to produce and what it will be used for.
2. **Acceptance criteria**: how the subagent knows it is done (checkable).
3. **Report format**: what to send back, with a length cap.

Never delegate with just "look into X". Use the templates in
`playbooks/delegation-templates.md`.

## Report contract — what comes back to the main thread

- Conclusions and decisions only, with `file:line` references.
- Long artifacts (reports, generated code, scan results) are SAVED TO A FILE;
  the reply contains the path plus a ≤10-line summary.
- Reply hard cap ~30 lines. If a subagent needs to say more, it writes a file.
- A subagent that cannot meet the acceptance criteria says so explicitly and
  reports what it tried — never a fake success.

## Escalation & de-escalation ladder

- `haiku` gets it wrong once → redo on `sonnet`. Don't debug haiku's attempt.
- `sonnet` fails the SAME subtask twice → escalate to `opus`, passing the full
  failure trail (both attempts, errors, what was ruled out) — not a fresh prompt.
- Once the hard instance is solved and a pattern exists → hand the pattern back
  to `haiku`/`sonnet` for batch application to remaining cases.
- Hard stop: max 2 retry rounds on the same approach. Then either change
  approach (see `playbooks/judgment.md` § wrong-direction signals) or ask the
  user. Never loop a third identical retry, on any model.

## Verification is never self-verification

- Files written → a FRESH subagent (haiku) reads them back and checks the
  acceptance criteria, not the author agent.
- Code → tests or an actual run (build, curl, `/browse`) beat any review.
- High-stakes judgment (irreversible ops, architecture picks, public text) →
  second opinion from a fresh `opus` agent or `/codex` if available; for
  taste-based outputs, generate 2–3 variants and have a judge agent pick.

## Fallback when the Agent tool is unavailable

If Agent calls are denied/absent (was the case before 2026-07-04 — check
`permissions.deny` in `~/.claude/settings.json`):

```bash
claude -p --model claude-sonnet-5 "<prompt incl. file paths, acceptance criteria, report format>"
```

Tested working 2026-07-04. Runs fresh-context, can read files in cwd. Slower
and unparallel — prefer the Agent tool whenever present. Note: settings.json
edits (e.g. removing a deny) take effect for TOOL AVAILABILITY only after a
session restart, though hook/agent lists may refresh sooner.
