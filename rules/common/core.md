# Engineering Defaults

> Always loaded. Keep under 200 lines — long material belongs in
> `~/.claude/playbooks/` (loaded on demand). Rationale for these rules:
> `~/.claude/playbooks/harness-diagnosis.md`.

## Shell tools

Use specialized tools (install if missing):

| Task | Use | Not |
|------|-----|-----|
| Find files | `fd` | `find`, `ls -R` |
| Search text | `rg` | `grep`, `ag` |
| Code structure | `ast-grep` | `grep`, `sed` |
| JSON | `jq` | `python -m json.tool` |
| YAML/XML | `yq` | manual parsing |

## Code style

- Prefer immutability: return new objects instead of mutating arguments.
  (Language rules in `~/.claude/rules/<lang>/` may override where mutation is
  idiomatic, e.g. Go.)
- Small units: functions <50 lines; files 200–400 lines typical, 800 hard max.
  Organize by feature/domain, not by type.
- Handle errors explicitly at every level. User-facing code shows friendly
  messages; server side logs full context. Never silently swallow an error.
- Validate all external input at system boundaries (user input, API responses,
  file content). Use schema validation where available. Fail fast.
- No hardcoded secrets or magic values — use env vars / constants / config.
- Match the surrounding code's idiom and comment density. Comment only
  constraints the code cannot express.

## Testing — when tests are required

Do NOT chase a coverage number. Use these triggers:

| Change | Tests required |
|---|---|
| New business logic (calculations, state machines, parsers) | Unit tests, yes |
| Bug fix | Regression test that reproduces the bug BEFORE the fix |
| Auth, payments, data deletion/migration | Tests incl. edge cases — non-negotiable |
| API endpoint added/changed | At least one integration test |
| Pure styling, copy, layout, config rename | No tests needed |

- Never modify a test just to make it pass. First explain (to the user or in
  the commit message) why the test was wrong.
- For new features with clear inputs/outputs, prefer the `/tdd` skill
  (test first, watch it fail, implement, watch it pass).

## Security — before any commit

- [ ] No secrets (keys, passwords, tokens) in code or logs
- [ ] SQL through parameterized queries only
- [ ] User-supplied HTML sanitized; user input validated
- [ ] Error messages don't leak internals

If a secret was exposed: stop the current task, tell the user, rotate it,
then `rg` the repo for similar exposures.

## Git

- Conventional commits: `<type>: <description>` where type ∈
  feat|fix|refactor|docs|test|chore|perf|ci. No AI-attribution footers
  (disabled by user settings).
- Commit or push only when the user asks. Never commit directly on `main` —
  branch first.
- PRs: diff against the base branch (`git diff base...HEAD`), summarize ALL
  commits, include a test plan.

## Browser & web

- Use the `/browse` skill (gstack headless browser) for all web testing and
  browsing. Never call `mcp__claude-in-chrome__*` tools.
