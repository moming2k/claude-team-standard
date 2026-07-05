# Letter to Future Sessions

> Written 2026-07-04 by the Fable 5 session that built this institution
> (diagnosis → CLAUDE.md router → core/delegation rules → judgment/templates/
> maintenance playbooks). You are probably a smaller model. That's fine — this
> system was designed so you don't need to be brilliant, just disciplined.
>
> NOTE for new installs of this team standard: the "Three things" section
> below describes the ORIGINAL author's machine (their plugins, their
> settings.json). On a fresh install, re-derive the machine-specific items
> for your own environment; the degradation modes and confidence report
> transfer as-is.

## Three things the user didn't ask about, but matter most

1. **Hook and plugin sprawl is the next cleanup.** Four observability
   integrations (vibecraft, vibe-island, pixel-agents, ccani) fire on every
   tool call — some with 5s timeouts — and four workflow stacks inject 100+
   skill descriptions per session. The always-loaded rules are now lean, but
   the plugin layer isn't. Suggest to the user a one-hour audit: keep the
   integrations they actually look at, disable the rest in settings.json /
   `claude plugin` — with their approval, per maintenance.md.

2. **`skipDangerousModePermissionPrompt: true` is optional — use with care.**
   Combined with an autonomous-leaning workflow it removes a real safety net.
   If it's enabled, make sure that was a deliberate choice, and treat
   guardrail skills like `/careful` or `/guard` before risky work as the
   compensating control.

3. **This institution only compounds if lessons actually get written.** The
   mechanism that turns a weak model into a strong system is the loop:
   mistake → `lessons.md` → compaction → better rules. Memory has one real
   entry after months of use; the loop was not running. When something bites
   you, spend the 60 seconds to log it. That habit is worth more than any
   single rule in these files.

## How this system will most likely degrade — and the antidote

- **Accretion:** sessions append "one more rule" to always-loaded files until
  the context is bloated and self-contradictory again (that's exactly the
  state this was rescued from). Antidote: the edit-permission table and hard
  line budgets in maintenance.md. Additions go to lessons.md, not CLAUDE.md.
- **Staleness:** model IDs, skill names, and tool behaviors in these files rot
  as the platform evolves. Antidote: every environmental claim carries
  `(verified YYYY-MM-DD)`; compaction sessions re-verify anything >2 months
  old; when a claim fails in practice, check the live environment and log a
  lesson — never guess a replacement.
- **Silent abandonment:** future sessions simply don't read the playbooks and
  drift back to defaults. Antidote: CLAUDE.md is always loaded and routes to
  them by trigger; if you notice a session (including yourself) ignoring the
  router, log it as a lesson — that's a signal the trigger table needs
  sharper wording, not that the system failed.

## Honest confidence report (lowest first)

1. **Escalation thresholds** (haiku: 1 miss; sonnet: 2 misses; 2 retry
   rounds) — plausible heuristics, not measured on this user's workload.
   Tune via lessons.md when reality disagrees.
2. **`claude -p` fallback economics** — it works (tested 2026-07-04), but how
   it bills against the subscription, and whether safety-routed requests
   (some requests may silently run on Opus 4.8) consume this window's quota,
   is UNCONFIRMED. Verify on the claude.ai usage dashboard before leaning on
   it heavily.
3. **Rules auto-loading mechanics** — "no `paths:` frontmatter → always
   loaded; playbooks/ never auto-loaded" was verified on Claude Code 2.1.201
   only. Re-verify after major CLI upgrades (a change here silently breaks
   the whole budget design).
4. **The workflow routing table** — gstack-primary was the user's call, but I
   mapped intents→skills from descriptions, not from using each skill. If a
   listed skill behaves differently than its description, fix the table (user
   approval) and log it.
5. **Judgment rubrics** — I believe these transfer well to smaller models,
   but rubrics can't fully replace taste. For genuinely ambiguous or
   taste-heavy calls (naming, product copy, "is this design good"), the
   honest move remains: escalate the model, get an outside second opinion
   (/codex), or tell the user it's a judgment call they should make.
