#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "b2nkuu-spirit install"
echo "─────────────────────"

# Skills
mkdir -p "$CLAUDE_DIR/skills"
cp "$REPO_DIR/.claude/skills/"*.md "$CLAUDE_DIR/skills/"
echo "skills   → ~/.claude/skills/"

# Hooks
mkdir -p "$CLAUDE_DIR/hooks"
cp "$REPO_DIR/.claude/hooks/"*.sh "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/"*.sh
echo "hooks    → ~/.claude/hooks/"

# CLAUDE.md — add @import if not already there
IMPORT_LINE="@$REPO_DIR/CLAUDE.md"
GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
touch "$GLOBAL_CLAUDE"
if ! grep -qF "$IMPORT_LINE" "$GLOBAL_CLAUDE"; then
  printf "\n# b2nkuu-spirit\n%s\n" "$IMPORT_LINE" >> "$GLOBAL_CLAUDE"
  echo "CLAUDE.md → import added"
else
  echo "CLAUDE.md → already imported"
fi

# settings.json — merge hooks (skip if command already exists)
python3 - <<PYEOF
import json, os

src = "$REPO_DIR/.claude/settings.json"
dst = "$CLAUDE_DIR/settings.json"

with open(src) as f:
    spirit = json.load(f)

existing = {}
if os.path.exists(dst):
    with open(dst) as f:
        try:
            existing = json.load(f)
        except json.JSONDecodeError:
            pass

hooks = existing.setdefault("hooks", {})
for event, handlers in spirit.get("hooks", {}).items():
    if event not in hooks:
        hooks[event] = handlers
        continue
    existing_cmds = {
        h["command"]
        for group in hooks[event]
        for h in group.get("hooks", [])
        if "command" in h
    }
    for group in handlers:
        new_hooks = [h for h in group.get("hooks", []) if h.get("command") not in existing_cmds]
        if new_hooks:
            hooks[event].append({**group, "hooks": new_hooks})

with open(dst, "w") as f:
    json.dump(existing, f, indent=2)
PYEOF
echo "settings → hooks merged"

echo ""
echo "Done. Restart Claude Code to apply."
