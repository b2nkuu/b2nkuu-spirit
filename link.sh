#!/bin/bash
# Per-project setup — run from project root after adding as submodule:
#   git submodule add <url> .spirit
#   bash .spirit/link.sh
set -euo pipefail

SPIRIT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(pwd)"
SPIRIT_REL="${SPIRIT_DIR#$PROJECT_DIR/}"

echo "b2nkuu-spirit link"
echo "──────────────────"
echo "spirit: $SPIRIT_REL"

# .claude/skills — symlink (relative, so works after clone)
mkdir -p "$PROJECT_DIR/.claude"
if [ -e "$PROJECT_DIR/.claude/skills" ] || [ -L "$PROJECT_DIR/.claude/skills" ]; then
  rm -rf "$PROJECT_DIR/.claude/skills"
fi
ln -sf "../$SPIRIT_REL/.claude/skills" "$PROJECT_DIR/.claude/skills"
echo "skills   → .claude/skills (symlink)"

# CLAUDE.md — add @import
IMPORT_LINE="@$SPIRIT_REL/CLAUDE.md"
CLAUDE_MD="$PROJECT_DIR/CLAUDE.md"
touch "$CLAUDE_MD"
if ! grep -qF "$IMPORT_LINE" "$CLAUDE_MD"; then
  printf "\n# b2nkuu-spirit\n%s\n" "$IMPORT_LINE" >> "$CLAUDE_MD"
  echo "CLAUDE.md → import added"
else
  echo "CLAUDE.md → already imported"
fi

# .claude/settings.json — hooks point to submodule path (no ~/.claude needed)
python3 - <<PYEOF
import json, os

dst = "$PROJECT_DIR/.claude/settings.json"
spirit_rel = "$SPIRIT_REL"

new_hooks = {
  "UserPromptSubmit": [
    {"hooks": [{"type": "command", "command": f"bash {spirit_rel}/.claude/hooks/route-mindset.sh"}]}
  ],
  "Stop": [
    {"hooks": [{"type": "command", "command": f"bash {spirit_rel}/.claude/hooks/kaizen-reflect.sh"}]}
  ]
}

existing = {}
if os.path.exists(dst):
    with open(dst) as f:
        try:
            existing = json.load(f)
        except json.JSONDecodeError:
            pass

hooks = existing.setdefault("hooks", {})
for event, handlers in new_hooks.items():
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
        new = [h for h in group.get("hooks", []) if h.get("command") not in existing_cmds]
        if new:
            hooks[event].append({**group, "hooks": new})

with open(dst, "w") as f:
    json.dump(existing, f, indent=2)
PYEOF
echo "settings → hooks configured (project-local)"

echo ""
echo "Done. Restart Claude Code to apply."
