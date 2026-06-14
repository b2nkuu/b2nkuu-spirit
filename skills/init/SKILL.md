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
3. Print a summary of what was created vs. skipped.

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

### 4. Summary

Print one block. Use the marks captured above:

```
✅ spirit init complete
   .gitignore         : <created|appended|kept>
   .spirit/reflections: <created|kept>
```

## Idempotency

Running `/spirit:init` a second time on the same repo must produce zero file changes and report `kept` for every line. `git status` immediately after a second run must show no diff caused by this skill.
