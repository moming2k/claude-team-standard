# Knowledge Loop — self-learning that survives model changes

> On-demand file. Read when: promoting lessons, running a compaction session,
> or syncing this standard with the team repo. The design goal: the SYSTEM
> gets smarter over time even if the models running it get weaker.

## Three tiers of knowledge

| Tier | Lives in | Shared? | Who writes | Bar to enter |
|---|---|---|---|---|
| 0 — machine | `playbooks/lessons.md`, Claude memory | never | any session, append-only | it bit you once |
| 1 — team playbooks | `playbooks/*.md` in the team repo | via git PR | compaction session | recurring (≥2 times) or clearly general |
| 2 — always-loaded | `CLAUDE.md`, `rules/common/` | via git PR + human review | humans merge, models propose | changes behavior on EVERY task AND fits the line budget |

Knowledge flows UP only through compaction. Nothing skips a tier: a session
may never write a fresh observation directly into Tier 1 or 2.

## The loop

1. **Capture** (every session): something bit you — broken assumption, cut
   retry loop, user correction — append one entry to `lessons.md` in the
   format from `maintenance.md`. 60 seconds. This is the habit the whole
   system depends on.
2. **Compact** (~monthly, or when `lessons.md` >150 lines): run the runbook
   below on the strongest model available to you.
3. **Share**: promoted lessons go to the team repo as a PR — sanitized
   (checklist below), one branch per compaction. A HUMAN teammate reviews
   and merges. Human review is the quality gate that replaces top-model
   judgment on shared knowledge.
4. **Pull**: teammates update by pulling the repo and re-running
   `install.sh` — it never overwrites a machine's local `lessons.md`.

## Sanitize before sharing (the repo is PUBLIC)

Strip from any lesson before it leaves the machine:

- Names, emails, client/product identifiers, and repo paths that reveal them.
- Hostnames, IPs, account names — anything about infrastructure.
- Security-posture facts ("X is disabled on my machine") — convert to
  conditional guidance ("if X is disabled, then …").
- Rewrite the Trigger as a generic scenario; keep the executable Lesson
  rule intact.

If a lesson cannot be made generic without losing its point, it stays
Tier 0. That is a valid outcome, not a failure.

## Compaction runbook (designed to be run by a Sonnet-class model)

1. Read `lessons.md` and this file. Work on a branch of the team repo.
2. Classify each lesson: PROMOTE (recurring or clearly general) / KEEP
   (young or unclear — leave in lessons.md) / DROP (stale, superseded, or
   one-off).
3. Apply promotions to the matching playbook. NEVER edit Tier 2 files
   directly — write proposed Tier 2 changes into the PR description for the
   human reviewer to apply or reject.
4. Re-verify every `(verified YYYY-MM-DD)` claim older than ~2 months
   (model IDs, tool names, CLI behavior) against the live environment.
5. Adversarial review: a FRESH agent runs template §5 of
   `delegation-templates.md` against every changed file. Fix findings.
6. Check line budgets (`maintenance.md`). Sanitize (section above).
7. Commit `docs: compaction YYYY-MM`, push, open a PR listing each
   promotion with the origin lesson it came from. Delete promoted and
   dropped entries from local `lessons.md` only AFTER the PR merges.

## Cross-machine model

Each teammate clones the team repo once; `install.sh` copies it into
`~/.claude/`. Local `lessons.md` and Claude memory stay local — only
compaction PRs move knowledge. Disagreements between machines' lessons are
resolved in PR review conversation, never by silently overwriting.
