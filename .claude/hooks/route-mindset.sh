#!/bin/bash
# B2NKUU Spirit — Mindset Router
# Reads UserPromptSubmit JSON from stdin, detects task type, injects relevant mindset

INPUT=$(cat)

# Extract prompt text
PROMPT=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('prompt', '').lower())
except Exception:
    pass
" 2>/dev/null)

if [ -z "$PROMPT" ]; then
  exit 0
fi

# Check if Superpowers plugin is installed
SUPERPOWERS_INSTALLED=$(python3 -c "
import json, os
try:
    f = os.path.expanduser('~/.claude/plugins/installed_plugins.json')
    d = json.load(open(f))
    print('yes' if any('superpowers' in k for k in d.get('plugins', {})) else 'no')
except Exception:
    print('no')
" 2>/dev/null)

INJECTION=""

if echo "$PROMPT" | grep -qE '\b(debug|error|bug|fix|broken|crash|fail|exception|traceback|incident)\b|บั๊ก|บัค|พัง|ไม่ทำงาน|ทำไมถึง|แก้บั๊ก|หาสาเหตุ'; then
  INJECTION="[GAMAN] Endure with patience. Understand root cause before proposing any fix. Ask why five times. Do not patch symptoms."
  [ "$SUPERPOWERS_INSTALLED" = "yes" ] && INJECTION="$INJECTION Use the systematic-debugging skill for the process."

elif echo "$PROMPT" | grep -qE '\b(review|quality|check|inspect|assess|pr|pull request|lgtm)\b|รีวิว|ตรวจ code|เช็ค code|ดูคุณภาพ'; then
  INJECTION="[SHOKUNIN] Review as a master craftsman. Every name, structure, and decision reflects care or its absence. Name what excels and what can improve."
  [ "$SUPERPOWERS_INSTALLED" = "yes" ] && INJECTION="$INJECTION Use the requesting-code-review skill for the process."

elif echo "$PROMPT" | grep -qE '\b(refactor|improve|clean|cleanup|restructure|simplify|reorganize)\b|ปรับปรุง|จัดระเบียบ|ทำให้ดีขึ้น|ปรับ code'; then
  INJECTION="[KAIZEN] Improve incrementally. Identify the smallest valuable change. Change one thing at a time. Stop at better, not perfect."
  [ "$SUPERPOWERS_INSTALLED" = "yes" ] && INJECTION="$INJECTION Use the test-driven-development skill for safe incremental changes."

elif echo "$PROMPT" | grep -qE '\b(plan|design|architect|feature|build|create|proposal|why|should we)\b|วางแผน|ออกแบบ|ทำไม|ควรจะ|สร้าง feature'; then
  INJECTION="[IKIGAI] Start with purpose. Who is this for? What problem does it solve today? Define done measurably before writing code."
  [ "$SUPERPOWERS_INSTALLED" = "yes" ] && INJECTION="$INJECTION Use the writing-plans skill to structure the plan."
fi

if [ -n "$INJECTION" ]; then
  python3 -c "
import json, sys
print(json.dumps({'prompt_injection': sys.argv[1]}))
" "$INJECTION"
fi
