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

INJECTION=""

if echo "$PROMPT" | grep -qE '\b(debug|error|bug|fix|broken|crash|fail|exception|traceback|incident)\b'; then
  INJECTION="[GAMAN] Endure with patience. Understand root cause before proposing any fix. Ask why five times. Do not patch symptoms."

elif echo "$PROMPT" | grep -qE '\b(review|quality|check|inspect|assess|pr|pull request|lgtm)\b'; then
  INJECTION="[SHOKUNIN] Review as a master craftsman. Every name, structure, and decision reflects care or its absence. Name what excels and what can improve."

elif echo "$PROMPT" | grep -qE '\b(refactor|improve|clean|cleanup|restructure|simplify|reorganize)\b'; then
  INJECTION="[KAIZEN] Improve incrementally. Identify the smallest valuable change. Change one thing at a time. Stop at better, not perfect."

elif echo "$PROMPT" | grep -qE '\b(plan|design|architect|feature|build|create|proposal|why|should we)\b'; then
  INJECTION="[IKIGAI] Start with purpose. Who is this for? What problem does it solve today? Define done measurably before writing code."
fi

if [ -n "$INJECTION" ]; then
  python3 -c "
import json, sys
print(json.dumps({'prompt_injection': sys.argv[1]}))
" "$INJECTION"
fi
