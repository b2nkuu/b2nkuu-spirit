#!/bin/bash
# B2NKUU Spirit — Kaizen Reflection
# Persists session reflection prompts so improvements compound over time.
# Triggered on Stop event.

REFLECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}/.spirit/reflections"
mkdir -p "$REFLECT_DIR"

LOG_FILE="$REFLECT_DIR/$(date +%Y-%m-%d).log"
TIMESTAMP="$(date +%H:%M:%S)"

{
  echo ""
  echo "── $TIMESTAMP ──"
  echo "1. What did you improve today?"
  echo "2. What did you leave better than you found it?"
  echo "3. What's one thing to do differently next session?"
} >> "$LOG_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  改善 KAIZEN REFLECTION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  1. What did you improve today?"
echo "  2. What did you leave better than you found it?"
echo "  3. What's one thing to do differently next session?"
echo ""
echo "  logged → $LOG_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
