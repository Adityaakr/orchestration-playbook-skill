#!/usr/bin/env bash
# prism-guard.sh — Claude Code PreToolUse hook (matcher: Bash).
#
# ENFORCES the "stop at one-way doors" guard that /prism-implement only *promises*
# to follow. The model cannot bypass this — it runs before the Bash tool executes.
#
# Blocks irreversible / outward-facing commands (deploy, publish, force-push,
# destructive deletes, db migrations, mainnet contract calls) UNLESS the user has
# explicitly approved, signalled by appending the token  # PRISM_OK  to the command.
#
# Exit 0 = allow.  Exit 2 = block (stderr is shown to the model so it asks the user).
#
# Wire it up in settings.json:
#   "hooks": { "PreToolUse": [ { "matcher": "Bash",
#     "hooks": [ { "type": "command", "command": "bash ~/.claude/hooks/prism-guard.sh" } ] } ] }

set -uo pipefail
input=$(cat)

cmd=$(printf '%s' "$input" | python3 -c 'import sys,json
try:
    d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))
except Exception:
    print("")' 2>/dev/null || true)

[ -z "$cmd" ] && exit 0

# Explicit, user-granted override escape hatch.
case "$cmd" in *PRISM_OK*) exit 0 ;; esac

# One-way doors: irreversible or externally-visible side effects.
danger='git push[^|]*(--force|-f( |$)|\+)|git push[^|]*( origin)? (main|master)( |$)|npm publish|yarn publish|pnpm publish|vercel[^|]*--prod|netlify deploy[^|]*--prod|gh release create|gh repo delete|supabase db push|supabase db reset|prisma migrate deploy|prisma migrate reset|drizzle-kit push|forge create|forge script[^|]*--broadcast|cast send|rm -rf|git reset --hard|git clean -[a-z]*f|drop +(table|database)|truncate +table'

if printf '%s' "$cmd" | grep -iEq "$danger"; then
  {
    echo "prism-guard BLOCKED a one-way-door command:"
    echo "    $cmd"
    echo
    echo "This is irreversible or outward-facing (deploy / publish / force-push /"
    echo "destructive delete / db migration / mainnet tx). Per the prism harness you"
    echo "must confirm with the USER before running it."
    echo
    echo "If the user explicitly approves, re-issue the command with a trailing"
    echo "approval token, e.g.:"
    echo "    $cmd   # PRISM_OK"
  } >&2
  exit 2
fi

exit 0
