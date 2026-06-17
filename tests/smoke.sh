#!/bin/bash
# spirit hook smoke tests — run locally or in CI.
# Usage: bash tests/smoke.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0

run() {
  local name="$1"
  shift
  if "$@"; then
    echo "  ✓ $name"
    PASS=$((PASS + 1))
  else
    echo "  ✗ $name"
    FAIL=$((FAIL + 1))
  fi
}

# --- route-mindset ---------------------------------------------------------

echo "route-mindset.sh"

t_route_gaman() {
  local out
  out=$(echo '{"prompt":"debug this error"}' | bash hooks/route-mindset.sh)
  echo "$out" | jq -e '.hookSpecificOutput.additionalContext | test("GAMAN")' > /dev/null
}
run "GAMAN injected for debug keyword" t_route_gaman

t_route_kaizen() {
  local out
  out=$(echo '{"prompt":"refactor this"}' | bash hooks/route-mindset.sh)
  echo "$out" | jq -e '.hookSpecificOutput.additionalContext | test("KAIZEN")' > /dev/null
}
run "KAIZEN injected for refactor keyword" t_route_kaizen

t_route_ikigai() {
  local out
  out=$(echo '{"prompt":"design a feature"}' | bash hooks/route-mindset.sh)
  echo "$out" | jq -e '.hookSpecificOutput.additionalContext | test("IKIGAI")' > /dev/null
}
run "IKIGAI injected for design keyword" t_route_ikigai

t_route_shokunin() {
  local out
  out=$(echo '{"prompt":"review my pull request"}' | bash hooks/route-mindset.sh)
  echo "$out" | jq -e '.hookSpecificOutput.additionalContext | test("SHOKUNIN")' > /dev/null
}
run "SHOKUNIN injected for review keyword" t_route_shokunin

t_route_implement() {
  local out
  out=$(echo '{"prompt":"implement this feature"}' | bash hooks/route-mindset.sh)
  echo "$out" | jq -e '.hookSpecificOutput.additionalContext | test("SHOKUNIN\\+KAIZEN")' > /dev/null
}
run "SHOKUNIN+KAIZEN injected for implement keyword" t_route_implement

t_route_no_kanso() {
  local out
  out=$(echo '{"prompt":"explain this code"}' | bash hooks/route-mindset.sh)
  [ -z "$out" ]
}
run "Kanso NOT injected (removed in favor of pordee)" t_route_no_kanso

t_route_no_match() {
  local out
  out=$(echo '{"prompt":"hello"}' | bash hooks/route-mindset.sh)
  [ -z "$out" ]
}
run "no injection for unrelated prompt" t_route_no_match

# --- branch-guard ----------------------------------------------------------

echo "branch-guard.sh"

GUARD_REPO=$(mktemp -d)
git -C "$GUARD_REPO" init -q -b main
git -C "$GUARD_REPO" config user.email "test@spirit.local"
git -C "$GUARD_REPO" config user.name "spirit-test"
git -C "$GUARD_REPO" commit -q --allow-empty -m init

t_guard_blocks_edit_on_main() {
  local out
  out=$(echo '{"tool_name":"Edit","tool_input":{"file_path":"x"}}' \
    | CLAUDE_PROJECT_DIR="$GUARD_REPO" bash hooks/branch-guard.sh)
  echo "$out" | jq -e '.hookSpecificOutput.permissionDecision == "deny"' > /dev/null
}
run "blocks Edit on main" t_guard_blocks_edit_on_main

t_guard_blocks_commit_on_main() {
  local out
  out=$(echo '{"tool_name":"Bash","tool_input":{"command":"git commit -m x"}}' \
    | CLAUDE_PROJECT_DIR="$GUARD_REPO" bash hooks/branch-guard.sh)
  echo "$out" | jq -e '.hookSpecificOutput.permissionDecision == "deny"' > /dev/null
}
run "blocks git commit on main" t_guard_blocks_commit_on_main

t_guard_allows_read_bash() {
  local out
  out=$(echo '{"tool_name":"Bash","tool_input":{"command":"git status"}}' \
    | CLAUDE_PROJECT_DIR="$GUARD_REPO" bash hooks/branch-guard.sh)
  [ -z "$out" ]
}
run "allows read-only Bash on main" t_guard_allows_read_bash

t_guard_allows_edit_on_feature() {
  git -C "$GUARD_REPO" checkout -q -b feature/x
  local out
  out=$(echo '{"tool_name":"Edit","tool_input":{"file_path":"x"}}' \
    | CLAUDE_PROJECT_DIR="$GUARD_REPO" bash hooks/branch-guard.sh)
  [ -z "$out" ]
}
run "allows Edit on feature/ branch" t_guard_allows_edit_on_feature

rm -rf "$GUARD_REPO"

# --- plugin.json -----------------------------------------------------------

echo "plugin.json"

t_plugin_name() {
  jq -e '.name == "spirit"' .claude-plugin/plugin.json > /dev/null
}
run "name is 'spirit'" t_plugin_name

t_plugin_calver() {
  jq -e '.version | test("^[0-9]{4}\\.[0-9]{2}\\.[0-9]{2}$")' \
    .claude-plugin/plugin.json > /dev/null
}
run "version matches CalVer YYYY.MM.DD" t_plugin_calver

# --- summary ---------------------------------------------------------------

echo ""
echo "──────────────────────────────────────────"
echo "  $PASS passed, $FAIL failed"
echo "──────────────────────────────────────────"

[ "$FAIL" = "0" ]
