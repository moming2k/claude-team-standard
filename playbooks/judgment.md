# Judgment Rubrics

> On-demand file. Read when deciding: escalate? done? ask the user? change
> approach? Each rubric has a PASS example (do this) and a FAIL example
> (don't). Written 2026-07-04; tune thresholds via `lessons.md`, don't edit
> here mid-task.

## 1. When to escalate to a stronger model

Escalate when the TASK TYPE is judgment-heavy, or when the ladder in
`rules/common/delegation.md` says so (haiku wrong once; sonnet fails same
subtask twice). Escalate BEFORE burning retries when the task involves:
ambiguous requirements, cross-cutting architecture, security design, or
debugging where two attempts produced contradictory evidence.

- PASS: Sonnet subagent twice produced a migration script that fails on the
  same foreign-key error with different fixes. → Stop. Send opus the schema,
  both scripts, both error logs, and the constraint that data must survive.
- FAIL: A rename-across-repo task feels tedious, so you send it to opus.
  Tedious ≠ hard. Mechanical work stays on haiku/sonnet.

Never escalate to fix formatting, lint, or a typo in your own prompt. Fix the
prompt and rerun the same model.

## 2. When a task is actually DONE

Done = ALL of:
1. Every acceptance criterion demonstrably met — "demonstrably" means you can
   point at evidence: test output, a screenshot, a read-back, a curl response.
2. Verification was run by something other than the author (fresh agent,
   test suite, real execution) — see delegation.md.
3. Nothing is left in a known-broken state (build passes, no half-applied edit).
4. The user-facing summary states what changed and what was verified, without
   hedging. If something was skipped, it says so explicitly.

- PASS: "Added rate limiting to /api/login. Integration test hits the endpoint
  11 times, asserts 429 on the 11th — output attached. Existing test suite
  still green (42 passed)."
- FAIL: "Added rate limiting. It should work now." — no evidence, "should" is
  a hedge, nothing verified. Not done.

If tests fail and you can't fix them within the retry budget: report DONE-WITH
-FAILURES with the failing output. Never report success with failing tests.

## 3. When to stop and ask the user

Ask (and block) only when the answer changes what you do next AND you cannot
resolve it from the request, the code, or a sensible default:

- Irreversible or outward-facing actions not explicitly requested: deleting
  data/branches, force-push, deploying to prod, sending/publishing anything,
  spending money.
- Two user instructions (or an instruction and this config) directly conflict.
- You discovered the task's premise is false (e.g. asked to fix a bug in code
  that doesn't exist) — report findings, don't invent a substitute task.
- Scope change: the fix genuinely requires touching systems the user didn't
  mention (auth, billing, schema).

Do NOT ask when: a convention exists in the codebase (follow it), the choice
is reversible (pick the obvious one, state it), or the info is discoverable
with a search (go find it).

- PASS: "The bug is caused by the DB schema — fixing it requires a migration
  that rewrites the orders table. That's beyond 'fix the date formatting' —
  proceed?" 
- FAIL: "I found the bug. Shall I fix it?" — fixing it was the task. Just fix it.

## 4. Wrong-direction signals — change approach, don't retry

Any ONE of these means STOP retrying and reframe (new hypothesis, different
layer, or ask):

- The same error survives two genuinely different fixes.
- Each fix creates a new failure somewhere else (whack-a-mole).
- Your fix requires touching more than ~3 files unrelated to the reported
  symptom.
- You're about to weaken an assertion / delete a test / add a sleep / catch
  and ignore an exception to make things pass.
- You cannot explain in one sentence WHY the current attempt should work.

Reframe procedure: write down (in your reply or a scratch file) what you now
KNOW is true, what you ruled out, and 2 candidate explanations you haven't
tested. Pick the cheapest discriminating experiment. If none exists → escalate
or ask, attaching that write-up.

- PASS: "Two CSS fixes didn't stop the layout shift. Ruled out: font loading,
  image dimensions. New hypothesis: it's the ad slot injecting height. Test:
  disable the ad script locally." 
- FAIL: Third retry of the same selector tweak "but stronger this time".

## 5. Quality floor — minimum verification by change type

| Change | Minimum verification before reporting done |
|---|---|
| Doc/config file written | Fresh haiku agent reads it back against acceptance criteria |
| Code change | Run the tests that cover it; if none exist, run the code path once for real |
| UI change | `/browse` screenshot of the actual rendered state |
| Deployment | Hit the live URL; check status + one core flow (`/canary` if long-running) |
| Destructive migration/script | Dry-run first; row counts before/after |
| Text that will be published | Second-opinion review (different model/context) |

"I read my own diff and it looks right" is never the floor. The author agent
checking its own work does not count as verification for any row above.
