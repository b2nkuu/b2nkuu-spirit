---
name: init
description: This skill should be used when the user runs `/spirit:init` to scaffold per-repo setup for spirit — adds `.spirit/` to `.gitignore` and creates `.spirit/reflections/`. One-time, idempotent.
version: 1.0.0
---
# Init

One-time, idempotent per-repo setup. Run once after `/plugin install github:b2nkuu/spirit` in a fresh repo so the `kaizen-reflect` Stop hook can write session logs without polluting git.

## What it does

1. Append `.spirit/` to the repo's `.gitignore` (create the file if missing; skip if already listed).
2. Create `.spirit/reflections/` if missing.
3. Verify the `kaizen-reflect` Stop hook is reachable; surface install instructions if not.
4. Print a summary of what was created vs. skipped.

## Steps

### 1. Locate repo root

```bash
git rev-parse --show-toplevel
```

Stop with `❌ Not a git repository — run inside a repo.` if this fails.

### 2. Ensure `.gitignore` lists `.spirit/`

Check for a line matching exactly `.spirit/` in `.gitignore`:

- **No `.gitignore`** → create it with a single line `.spirit/`. Mark as `created`.
- **Exists, no `.spirit/` line** → append `.spirit/` on its own line (prefix with a blank line if the file did not already end with one). Mark as `appended`.
- **Already present** → no-op. Mark as `kept`.

Match exact line — do not treat `.spiritual/` or `# .spirit/` as a hit.

### 3. Ensure `.spirit/reflections/` exists

```bash
mkdir -p .spirit/reflections
```

Mark as `created` if the directory was missing, `kept` otherwise.

### 4. Verify `kaizen-reflect` hook is reachable

Best-effort check — the hook ships with the spirit plugin. Look for any of these signals:

- `$CLAUDE_PLUGIN_ROOT` is set and points at a `spirit` path (skill running inside the plugin).
- `~/.claude/plugins/cache/b2nkuu/spirit/` exists.
- `.claude/settings.json` (repo) or `~/.claude/settings.json` (user) contains the literal string `kaizen-reflect`.

If **any** signal is present → mark as `ok`. Otherwise mark as `missing` and append this hint to the summary:

```
ℹ kaizen-reflect hook not detected. Install the plugin:
   /plugin install github:b2nkuu/spirit
```

Do not fail the run — the scaffold is still valid; the hook just won't fire until the plugin is installed.

### 5. Summary

Print one block. Use the marks captured above:

```
✅ spirit init complete
   .gitignore         : <created|appended|kept>
   .spirit/reflections: <created|kept>
   kaizen-reflect hook: <ok|missing>
```

If `kaizen-reflect hook` is `missing`, follow with the install hint shown in step 4.

## Idempotency

Running `/spirit:init` a second time on the same repo must produce zero file changes and report `kept` for `.gitignore` + `.spirit/reflections/`. `git status` immediately after a second run must show no diff caused by this skill. The hook check is observational and never writes to disk.
