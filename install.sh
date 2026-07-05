#!/usr/bin/env bash
# Install (or update) the Claude Code team standard into ~/.claude/.
# Safe to re-run: backs up replaced files, never overwrites local lessons.md.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DST="${CLAUDE_DIR:-$HOME/.claude}"
BK="$DST/backups/team-standard-$(date +%Y%m%dT%H%M%S)"

mkdir -p "$BK" "$DST/rules/common" "$DST/playbooks"

for path in CLAUDE.md rules playbooks; do
  if [ -e "$DST/$path" ]; then
    cp -R "$DST/$path" "$BK/"
  fi
done

cp "$SRC/CLAUDE.md" "$DST/CLAUDE.md"
cp "$SRC"/rules/common/*.md "$DST/rules/common/"

for p in "$SRC"/playbooks/*.md; do
  b="$(basename "$p")"
  if [ "$b" = "lessons.md" ] && [ -s "$DST/playbooks/lessons.md" ]; then
    echo "kept existing local playbooks/lessons.md (machine knowledge is never overwritten)"
    continue
  fi
  cp "$p" "$DST/playbooks/$b"
done

echo "Installed team standard into $DST"
echo "Backup of replaced files: $BK"
echo "Restart Claude Code so always-loaded files are re-read."
