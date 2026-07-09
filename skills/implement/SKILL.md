---
name: implement
description: This skill should be used when the user runs `/spirit:implement` to drive a full feature-development workflow on the current branch — reads the GitHub issue context from the branch name, explores the codebase, designs multiple approaches, implements with the user's chosen approach, and runs an adversarial review pass.
version: 1.0.0
---
# Implement

A structured, multi-step implementation workflow for solo + spirit users. Reads the issue context from the current branch name (set by `/solo:start`), then walks through discovery → exploration → design → implementation → review → summary so the work is grounded in both the issue's intent and the repo's existing conventions.

Modeled after the Claude Code `feature-dev` plugin, adapted to:

- Source intent from the GitHub issue (already filled by `/solo:plan`), not a free-text prompt.
- Wear spirit mindsets at each step (Ikigai → Shokunin → Kaizen → Gaman → Wabi-Sabi → Kanso).
- Hand off cleanly to `/solo:test` and `/solo:done` at the end.

## When to use

- After `/solo:start <n>` created a `feature/<n>-<slug>` (or similar) branch.
- When picking up an existing branch in a fresh session and you want a structured restart.
- For features that touch multiple files or need architectural decisions. For one-line fixes, just edit.

## Steps

### Step 0 — Resolve branch + issue *(Ikigai: anchor purpose before motion)*

1. Resolve repo:
   - `.solo/config.yml` `repo:` field (if present and not the `"owner/repo"` placeholder).
   - Else `gh repo view --json nameWithOwner -q .nameWithOwner`.
   - Else stop: `❌ Cannot resolve repo — set .solo/config.yml repo: or run inside a gh-mapped repo.`
2. Resolve current branch via `git branch --show-current`. Stop if detached HEAD.
3. Parse the issue number from the branch name using `.solo/config.yml` `branch.pattern` (default `{type}/{issue}-{slug}`). Translate tokens to regex (`{type}` → `[a-z]+`, `{issue}` → `(\d+)`, `{slug}` → `.+`); do not hardcode `feature/`.
4. Fetch the issue:
   ```bash
   gh issue view <n> --repo <owner/repo> --json number,title,body,labels,state,milestone
   ```
5. Error paths (stop with a clear message):
   - Branch does not match pattern → suggest `/solo:start <n>` or manual rename.
   - `gh` fails / issue not found → print stderr verbatim.
   - Issue closed → warn with close reason and ask `Continue anyway? [y/N]`. Stop on anything other than `y`.
6. Surface a compact context block:
   ```
   🌿 Branch  : <branch>
   📌 Issue   : #<n> <title>
   🏷  Labels  : <type:*>, <priority:*>, <size:*>
   📦 Milestone: <name>            ← only if set

   📋 Acceptance:
      - [<x or space>] <item>
   🧪 Test Plan:
      - [<x or space>] <item>
   ```

### Step 1 — Discovery *(Ikigai: confirm the "why" before the "how")*

Read the issue body's `## What`, `## Why`, and any `## Notes`. Decide whether intent is clear:

- **Clear** (AC items are concrete, `## What` describes observable behavior) → state your one-sentence understanding back and proceed.
- **Ambiguous** (AC has placeholders, `## What` is vague, behavior is underspecified) → ask 2–4 targeted clarifying questions inline. Stop until answered.

Output:
```
🎯 Goal: <one-sentence restatement>
Open questions:
  1. <question>
  …
```

If there are no open questions, omit the list.

### Step 2 — Codebase exploration *(Shokunin: understand the grain of the wood)*

Launch 2–3 `Explore` subagents **in parallel** (single message, multiple tool calls). Each agent has a distinct focus, derived from the issue body and AC. Pick from:

- Find features similar to this one and trace their implementation.
- Map the architecture/conventions of the area being touched (file layout, naming, test style).
- Surface integration points the new code will touch (existing modules, shared helpers, hooks).

Each `Explore` agent should return file paths with line numbers for key reading.

After they return, Claude reads the highest-signal files itself (≤ 5) before moving on. Summarize findings:

```
🔍 Exploration:
   Similar features:
     - <feature> (<file:line>) — <one-line summary>
   Conventions to follow:
     - <pattern> (<file:line>)
   Integration points:
     - <module> (<file:line>) — <what changes>
   Key files to read:
     - <file:line>
```

### Step 3 — Clarifying questions *(Gaman: be patient; do not skip ambiguity)*

After exploration, re-read the AC and ask any remaining gaps that the codebase did not answer. Common categories: edge cases, error handling, backward compatibility, performance, observability, telemetry, security boundary.

Present every question in one numbered list and wait for answers. If exploration covered everything, skip this step silently — do not invent questions.

### Step 4 — Architecture design *(Shokunin: interface before implementation)*

Launch 2–3 `Plan` subagents **in parallel**, each with a distinct lens:

1. **Minimal** — smallest possible change, maximum reuse of existing code.
2. **Clean** — best long-term shape (clear seams, easy to test) even if more files move.
3. **Pragmatic** — balance speed against debt; respect the conventions Step 2 surfaced.

Compare the three plans and form an opinion. Present:

```
🏛 Approach A (minimal): <one-line>
   Pros: …   Cons: …
🏛 Approach B (clean): <one-line>
   Pros: …   Cons: …
🏛 Approach C (pragmatic): <one-line>
   Pros: …   Cons: …

Recommendation: <A|B|C> — <why this fits>

Pick one? [A/B/C/edit]
```

`edit` lets the user paste a fourth option or modify a presented one. Wait for an explicit pick before proceeding.

### Step 5 — Implementation *(Kaizen: small steps; Wabi-Sabi: ship what is useful, name what is debt)*

Once an approach is picked:

1. **Persist the approach to the issue's `## Notes`** (run once, immediately after the user picks in Step 4):
   - Build the line: `- <YYYY-MM-DD>: [approach] <Letter>: <one-line summary of chosen approach>`
     - `<YYYY-MM-DD>` from `date +%Y-%m-%d`.
     - `<Letter>` is the picked option label: `A` (minimal), `B` (clean), `C` (pragmatic), or `Custom` for an edited/fourth option.
     - `<one-line summary>` is the Step 4 one-liner for the picked option, kept concise — no trailing period needed.
   - Concrete example (what the appended line must look like verbatim):
     ```
     - 2026-06-18: [approach] B: extract render helper into shared module so PR body + issue view reuse it
     ```
   - This exact format (the literal `[approach]` token followed by the letter, then `: `, then the summary) is what `/solo:done`'s rich PR body renderer scans for when building the "Approach" call-out in the PR Summary. Do not change the token, omit the letter, or drop the `: ` separator — all three are required for the call-out to render.
   - Fetch current body: `gh issue view <n> --repo <owner/repo> --json body -q .body`.
   - **Idempotency check**: if an identical `- <YYYY-MM-DD>: [approach] <Letter>: <summary>` line (same date + same letter + same summary) already exists in the body, skip the write entirely and note "approach line already present — skipping append" in Step 7's summary. This guards against re-running Step 5 in the same session.
   - **If a `## Notes` section exists** (regex: `(?m)^## Notes\s*$`): append the new line at the end of that section — before the next `##` heading, or before any trailing HTML comment block (e.g. `<!-- solo:metadata ... -->`), or at end-of-body otherwise. Preserve a single blank line between existing content and the appended line.
   - **If `## Notes` is missing**: create it. Insert `\n## Notes\n\n<line>\n` immediately before any trailing HTML comment block (e.g. `<!-- solo:metadata ... -->`), or at end-of-body otherwise. Keep a single blank line above the new heading.
   - Update the body via `gh issue edit <n> --repo <owner/repo> --body-file -` (pipe the new body on stdin to preserve newlines).
   - **Verify the write**: immediately after `gh issue edit`, re-fetch the body with `gh issue view <n> --repo <owner/repo> --json body -q .body` and confirm the exact `[approach] <Letter>:` line is present. If it is not, treat it as a write failure and surface it in Step 7 as "⚠ approach line not persisted: post-write verification missed the line".
   - On `gh` failure, print stderr verbatim and continue Step 5 — do not block implementation on a write failure; surface it in the Step 7 summary as "⚠ approach line not persisted: <reason>".
2. List the implementation steps as ordered todos (each ≤ 30 min of work).
3. Walk the todos one at a time. Update progress as you go.
4. Follow the conventions Step 2 surfaced — file layout, naming, tests, imports. Do not invent new patterns mid-feature.
5. If you discover a needed deviation from the picked approach, surface it immediately ("the assumption that X holds is false because Y — switching tactic to Z") rather than silently changing course.
6. Anything you intentionally leave imperfect (deferred test, known edge case, TODO) gets captured as a follow-up `/solo:capture` line at the end of this step, with a one-line `## Notes` rationale. Do not bury debt.

### Step 6 — Quality review + Dogfood verification *(Shokunin: review every line as if it were someone else's)*

**Step 6a — Dogfood verification (self-affecting spec changes).** Before the adversarial review pass, check whether the diff modifies any slash command specs that Claude itself will execute downstream. If so, **re-read the disk version of each affected spec file** and **simulate the new behavior manually** before declaring the implementation complete. Do not rely on the cached slash command body — disk is the source of truth for verification.

Example trigger paths (any diff touching these counts as a self-affecting spec change):

- solo: `commands/*.md` (slash command bodies that `/solo:*` commands execute)
- spirit: `skills/*/SKILL.md` (skill specs that `/spirit:*` commands execute)
- downstream: any other plugin's `commands/*.md` or `skills/*/SKILL.md` that this Claude Code session has loaded and may invoke before reload

Skip rule — when to skip the dogfood step (no noise):

- If the diff only touches non-spec source files (regular code, tests, fixtures, hooks, docs that are not slash command specs), **skip dogfood verification entirely** (skip non-spec changes by default) and proceed straight to the adversarial review pass. Do not announce the skip; silence is the signal.
- The dogfood step runs **only when** at least one path in the diff matches a trigger path above.

Cache-lag scenario — why disk re-read is required:

Slash command bodies and skill specs are read into the Claude Code session at session start (and on `/reload-plugins`). Once cached, that body is what Claude follows when the user invokes the command — even if the file on disk has since been edited. When the current implementation work is itself a change to one of those specs, the *new* behavior lives only on disk; the *cached* behavior is what Claude will keep executing inside this session.

That mismatch is the cache lag. Concretely: a PR that edits `commands/foo.md` adds a new step to `/foo`, but if Claude runs `/foo` later in the same session to "verify" the change, Claude actually walks the pre-edit cached body and reports success against stale behavior. Reload happens only on a new session or explicit `/reload-plugins`.

Therefore, when the diff touches a self-affecting spec, the cached command body is not a trustworthy oracle. Treat the spec on disk as the source of truth: re-read the edited file with the file-read tool and walk through the new behavior step-by-step against the acceptance criteria before declaring the implementation complete.

Run an adversarial review pass over the diff. Two options depending on what's available:

- **Preferred:** invoke the project's `/code-review` skill (which already runs multi-agent review in this Claude Code setup). Pass the appropriate effort level for the issue size (`low` for size:xs/s, `medium` for size:m, `high` for size:l).
- **Fallback:** launch 2–3 review subagents in parallel via the generic Agent tool, each with a distinct lens:
  - Correctness / bugs
  - Simplicity / DRY / cleanup opportunities
  - Conventions / abstractions vs. the repo's existing style

Consolidate findings, sort by severity:

```
🪞 Review:
  High:
    - <finding> (<file:line>)
  Medium:
    - <finding> (<file:line>)
  Low / nits:
    - <finding> (<file:line>)

  [f]ix now / [l]ater (capture) / [p]roceed as-is
```

`l` captures each medium+ finding as a follow-up via `/solo:capture`. `p` records "review acknowledged" without changes — a Wabi-Sabi escape valve.

### Step 7 — Summary + handoff *(Kanso: say only what is needed)*

Print one block:

```
✅ Implementation pass complete on #<n> — <title>

  Approach: <A|B|C|custom>
  Approach line persisted to issue #<n> Notes — will surface as Approach call-out in /solo:done PR body Summary.
  (or: ⚠ approach line not persisted: <reason>)
  Files changed: <count>
    - <path>
    - …
  Decisions:
    - <decision>
  Follow-ups captured:
    - #<m> <title>          ← only if any
  Tech debt acknowledged:
    - <line>                ← only if any

Next:
  /solo:test <n>   — walk the Test Plan
  /solo:done <n>   — close + open PR (Summary will include the Approach call-out from Notes)
```

Step 7 is read-only on the issue body — it does not write the summary to GitHub (the `[approach]` line was already persisted in Step 5). The user advances state via `/solo:test` then `/solo:done`.

## Non-goals

- Does not create the branch (`/solo:start` does that).
- Does not commit, push, or open a PR (`/solo:done` does that).
- Does not mutate the issue body — read-only on GitHub.
- Does not skip steps on its own. The user can `[skip]` a step explicitly when it is clearly unneeded (e.g. trivial change), but the default is to walk all steps.

## Mindset map

| Step | Mindset | What it forces |
|-------|---------|----------------|
| 0     | —       | Anchor: which issue, which branch |
| 1 Discovery | Ikigai | Why are we building this? |
| 2 Exploration | Shokunin | Respect the grain of the codebase |
| 3 Clarify | Gaman | Do not start until ambiguity is gone |
| 4 Design | Shokunin | Interface before implementation |
| 5 Implement | Kaizen + Wabi-Sabi | Small steps; ship + name debt honestly |
| 6 Review + Dogfood | Shokunin | Every line as someone else's; re-read disk specs when work modifies slash command bodies |
| 7 Summary | Kanso | Say only what is needed |
