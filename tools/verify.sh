#!/usr/bin/env bash
# Structural checks for the datapack. Catches the mistakes that otherwise only
# surface as red text in-game: dangling function references, macro lines missing
# their leading '$', macros invoked without arguments, and malformed JSON.
#
# Usage:  bash tools/verify.sh
# Requires: bash + grep. Uses node for JSON checks if it is available.
#
# Note on style: every loop reads from a process substitution rather than a
# pipe. A "cmd | while read" loop runs its body in a subshell, so a failure
# recorded inside it is discarded and the script exits 0 on a broken pack.
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FN="$ROOT/pack/data/chunkloader/function"
fail=0

say() { printf '%s\n' "$*"; }
bad() { printf '  FAIL %s\n' "$*"; fail=1; }

say "== dangling function references =="
while read -r p; do
  [ -n "$p" ] || continue
  [ -f "$FN/$p.mcfunction" ] || bad "missing target: chunkloader:$p"
done < <(grep -rhoE 'function chunkloader:[a-z0-9_/]+' "$FN" | sed 's/function chunkloader://' | sort -u)

say "== macro syntax used on non-macro lines =="
while read -r line; do
  [ -n "$line" ] || continue
  bad "uses \$( ) without a leading \$: $line"
done < <(grep -rn '\$(' "$FN" | grep -v ':[0-9]*:\$')

say "== macro functions invoked without arguments =="
while read -r m; do
  [ -n "$m" ] || continue
  # '#' comment lines are skipped: they document the inline-argument call form.
  if grep -rhE "^[^#]*function chunkloader:$m" "$FN" | grep -vqE "function chunkloader:$m( with | \{)"; then
    bad "macro chunkloader:$m is called without 'with' or inline {args}"
  fi
done < <(grep -rlE '^\$' "$FN" | sed "s|$FN/||; s|\.mcfunction||" | sort)

say "== JSON validity =="
if command -v node >/dev/null 2>&1; then
  while read -r f; do
    [ -n "$f" ] || continue
    node -e "JSON.parse(require('fs').readFileSync(process.argv[1],'utf8'))" "$f" 2>/dev/null \
      || bad "invalid JSON: ${f#$ROOT/}"
  done < <(find "$ROOT/pack" -name '*.json' -o -name 'pack.mcmeta')
else
  say "  (node not found, skipping)"
fi

say "== pack_format =="
grep -q '"pack_format": *48' "$ROOT/pack/pack.mcmeta" || bad "pack_format should be 48 for Minecraft 1.21.1"

say "== 1.21+ directory layout (singular 'function', not 'functions') =="
[ -d "$FN" ] || bad "expected $FN"
while read -r d; do
  [ -n "$d" ] || continue
  bad "legacy plural directory: ${d#$ROOT/}"
done < <(find "$ROOT/pack" -type d -name 'functions')

say "== line endings =="
# A trailing CR rides along into the command and can break the last argument on
# a line. The repo pins these to LF in .gitattributes; this catches a bypass.
#
# Checked per file rather than with "grep -rl": under Git Bash the recursive
# form reports every file regardless of content, while the single-file form is
# correct. A check that always fails is as useless as one that never does.
while read -r f; do
  [ -n "$f" ] || continue
  if grep -qU "$(printf '\r')" "$f" 2>/dev/null; then
    bad "CRLF line endings: ${f#$ROOT/}"
  fi
done < <(find "$ROOT/pack" -type f)

if [ "$fail" -eq 0 ]; then say ""; say "All checks passed."; else say ""; say "Checks FAILED."; fi
exit "$fail"
