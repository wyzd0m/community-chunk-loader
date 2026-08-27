#!/usr/bin/env bash
# Structural checks for the datapack. Catches the mistakes that otherwise only
# surface as red text in-game: dangling function references, macro lines missing
# their leading '$', macros invoked without arguments, and malformed JSON.
#
# Usage:  bash tools/verify.sh
# Requires: bash + grep. Uses node for JSON checks if it is available.
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FN="$ROOT/pack/data/chunkloader/function"
fail=0

say() { printf '%s\n' "$*"; }
bad() { printf '  FAIL %s\n' "$*"; fail=1; }

say "== dangling function references =="
grep -rhoE 'function chunkloader:[a-z0-9_/]+' "$FN" | sed 's/function chunkloader://' | sort -u | while read -r p; do
  [ -f "$FN/$p.mcfunction" ] || bad "missing target: chunkloader:$p"
done

say "== macro syntax used on non-macro lines =="
if grep -rn '\$(' "$FN" | grep -v ':[0-9]*:\$' ; then
  bad "the lines above use \$( ) but do not start with \$"
fi

say "== macro functions invoked without arguments =="
macros=$(grep -rlE '^\$' "$FN" | sed "s|$FN/||; s|\.mcfunction||" | sort)
for m in $macros; do
  # Ignore '#' comment lines, which document the inline-argument call form.
  if grep -rhE "^[^#]*function chunkloader:$m" "$FN" | grep -vqE "function chunkloader:$m( with | \{)"; then
    bad "macro chunkloader:$m is called without 'with' or inline {args}"
  fi
done

say "== JSON validity =="
if command -v node >/dev/null 2>&1; then
  for f in "$ROOT/pack/pack.mcmeta" "$ROOT"/pack/data/minecraft/tags/function/*.json; do
    node -e "JSON.parse(require('fs').readFileSync(process.argv[1],'utf8'))" "$f" 2>/dev/null || bad "invalid JSON: $f"
  done
else
  say "  (node not found, skipping)"
fi

say "== pack_format =="
grep -q '"pack_format": *48' "$ROOT/pack/pack.mcmeta" || bad "pack_format should be 48 for Minecraft 1.21.1"

say "== 1.21+ directory layout (singular 'function', not 'functions') =="
[ -d "$FN" ] || bad "expected $FN"
find "$ROOT/pack" -type d -name 'functions' | while read -r d; do bad "legacy plural directory: $d"; done
find "$ROOT/pack" -type d -name 'tags' -exec test -d {}/functions \; -print 2>/dev/null | while read -r d; do bad "legacy plural tags dir under $d"; done

if [ "$fail" -eq 0 ]; then say ""; say "All checks passed."; else say ""; say "Checks FAILED."; fi
exit "$fail"
