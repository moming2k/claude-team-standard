# Delegation Prompt Templates

> On-demand file. Copy a template, fill every slot, then call the Agent tool.
> Model choice + escalation rules: `rules/common/delegation.md`.
> Every template ends with the same REPORT block — subagents return conclusions
> + `file:line`, save long output to a file, cap replies at ~30 lines.

Shared REPORT block (append to every delegation):

```
REPORT BACK:
- ≤30 lines. Conclusions first, then evidence as file:line references.
- If output is long (report/code/scan), save it under <scratchpad or agreed path>
  and return the path + a ≤10-line summary.
- If you cannot meet the acceptance criteria, say NOT DONE, what you tried,
  and what blocked you. Do not fake success.
```

## 1. SEARCH / SCAN  (model: haiku; subagent_type: Explore for read-only)

```
GOAL: Find <what> in <repo/path>. I need this to <why>.
SCOPE: Look in <dirs/globs>. Use rg/fd, not full-file reads, unless a match
  needs context.
ACCEPTANCE: Every location listed as file:line with a one-line note on what's
  there. State the search patterns you used, so misses can be judged.
DO NOT: modify files; read files outside scope.
+ REPORT block
```

Example fill: "GOAL: Find every place we construct a Stripe client in
server/, needed to centralize config. ACCEPTANCE: file:line list + the config
values each site uses + patterns tried (`rg -n 'Stripe\('` etc.)."

## 2. IMPLEMENT  (model: sonnet)

```
GOAL: Implement <feature/fix> in <files/area>. Motivation: <why / user story>.
CONTEXT: Read first: <file:line list>. Follow existing patterns in <file>.
  Constraints: <API shape, perf, style, what must NOT change>.
ACCEPTANCE:
  - <observable behavior 1>
  - Tests: <which tests to add/run>; full suite still green via <command>.
  - Build passes: <command>.
DO NOT: refactor unrelated code; add dependencies without flagging it.
+ REPORT block (include: files touched, test output tail)
```

## 3. REFACTOR / BATCH EDIT  (model: haiku if pattern is fixed, sonnet if judgment per site)

```
GOAL: Apply this exact transformation: <before → after example>.
SCOPE: <file list or glob>, N call sites found by <search pattern>.
ACCEPTANCE: All N sites transformed; zero behavior change; <build/test command>
  passes; `git diff --stat` matches expected file list.
DO NOT: "improve" anything beyond the stated transformation.
+ REPORT block (include: sites changed as file:line, any site that didn't fit
  the pattern — leave those UNTOUCHED and list them)
```

The "didn't fit → leave untouched and list" clause is mandatory: it's how the
commander finds the cases needing a smarter model.

## 4. RESEARCH  (model: sonnet; use WebSearch/WebFetch or docs)

```
GOAL: Answer: <specific question(s)>. This decides <decision it feeds>.
SOURCES: Prefer <official docs / repo code / registry>. Note publish dates;
  flag anything older than <threshold>.
ACCEPTANCE: Each question answered with a cited source (URL or file:line).
  Distinguish "verified fact" vs "inference". Unknown = say unknown.
DO NOT: pad with background I didn't ask for.
+ REPORT block (long findings → save to <path>.md)
```

## 5. REVIEW / VERIFY  (model: haiku for read-back; opus for high-stakes)

```
GOAL: Adversarially review <files/diff> which claims to satisfy:
  <paste the original acceptance criteria verbatim>.
You did NOT write this. Your job is to find where it fails, not to praise it.
CHECK: correctness vs criteria; internal contradictions; references to
  files/tools/models that don't exist (verify paths with fd/ls); statements a
  smaller model could misread (ambiguity).
ACCEPTANCE: Verdict per criterion (PASS/FAIL/UNCLEAR) + every finding as
  file:line + a one-line fix suggestion. Zero findings is a valid outcome only
  after stating what you checked.
+ REPORT block
```

## Anti-patterns (all models)

- Delegating without acceptance criteria ("take a look at the auth code").
- Asking a subagent to both implement AND verify its own work.
- Re-delegating a failed task with the identical prompt to the same model —
  change the prompt, the model, or the approach (delegation.md ladder).
- Pasting a subagent's full transcript into the main conversation.
