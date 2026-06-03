#!/bin/bash
# B2NKUU Spirit — Branch Guard
# Blocks Edit/Write/git-commit on main. Work must happen on feature/* or worktree/*.

INPUT=$(cat)

BRANCH=$(git -C "${CLAUDE_PROJECT_DIR:-$PWD}" rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$BRANCH" ] && exit 0
[ "$BRANCH" != "main" ] && exit 0

TOOL=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_name', ''))
except Exception:
    pass
" 2>/dev/null)

CMD=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except Exception:
    pass
" 2>/dev/null)

block() {
  python3 -c "
import json, sys
print(json.dumps({
    'hookSpecificOutput': {
        'hookEventName': 'PreToolUse',
        'permissionDecision': 'deny',
        'permissionDecisionReason': sys.argv[1]
    }
}))
" "$1"
  exit 0
}

case "$TOOL" in
  Edit|Write|NotebookEdit)
    block "On main branch. Create a feature/* or worktree/* branch first: git checkout -b feature/<name>"
    ;;
  Bash)
    if echo "$CMD" | grep -qE '^\s*git\s+commit\b|^\s*git\s+.*\s+commit\b'; then
      block "On main branch. Create feature/* or worktree/* branch before committing: git checkout -b feature/<name>"
    fi
    ;;
esac

exit 0
