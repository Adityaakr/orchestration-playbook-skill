#!/usr/bin/env bash
# prism-gate.sh — done-signal integrity check for /prism-implement.
#
# Catches the #1 way an implement loop cheats: faking a green by skipping/deleting
# tests, or landing secrets / leftover debug. Run it on the working diff BEFORE
# declaring a milestone done:   bash hooks/prism-gate.sh
#
# Exit 0 = clean.  Exit 1 = findings printed (fix them, don't suppress them).
# Heuristic, not exhaustive — a fast tripwire, not a replacement for review.

set -uo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"

diff=$(git diff HEAD 2>/dev/null; git diff --staged 2>/dev/null)
[ -z "$diff" ] && { echo "prism-gate: no diff to check."; exit 0; }

added=$(printf '%s\n' "$diff" | grep -E '^\+' | grep -vE '^\+\+\+')
findings=0
flag() { echo "  ⚠ $1"; findings=$((findings+1)); }

# Faked green: tests skipped/silenced
printf '%s\n' "$added" | grep -nEq '\.(skip|only)\(|\bx(it|describe|test)\(|@pytest\.mark\.skip|t\.Skip\(' \
  && flag "test skipped/silenced (.skip/.only/xit/Skip) — never weaken the done-signal to pass"

# Removed assertions (test deletions to force green)
printf '%s\n' "$diff" | grep -nEq '^-.*(expect\(|assert|\.should|require\.Equal)' \
  && flag "an assertion was DELETED — confirm this isn't to force a pass"

# Hardcoded secrets
printf '%s\n' "$added" | grep -nEq '(sk-[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|(api[_-]?key|secret|password|token)["'"'"' ]*[:=]["'"'"' ]*[A-Za-z0-9]{16,})' \
  && flag "possible hardcoded secret/key in the diff"

# Leftover debug
printf '%s\n' "$added" | grep -nEq '(console\.log\(|debugger;|binding\.pry|fmt\.Println\("DEBUG)' \
  && flag "leftover debug output (console.log/debugger/etc.)"

if [ "$findings" -gt 0 ]; then
  echo "prism-gate: $findings issue(s) — resolve before landing (do NOT suppress)."
  exit 1
fi
echo "prism-gate: clean ✓"
exit 0
