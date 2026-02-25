---
name: aggregate
description: Pull learnings and retrospective insights from all registered projects into the central knowledge base. Run periodically to keep cross-project knowledge current.
user-invocable: true
---
# Aggregate Cross-Project Learnings

Pull learnings and retro insights from all projects in `registry.yaml` into `knowledge/`.

## Steps

1. **Read `registry.yaml`** to get the list of managed projects with their paths.

2. **Ensure freshness** of each project's main worktree:
   - Run `git -C <path> pull --ff-only` to update to latest origin/main
   - If pull fails (dirty worktree, non-ff), warn the user and note the discrepancy
   - Report freshness status to the user before proceeding

3. **For each project**, read:
   - `<path>/<docs.learnings>` (typically `docs/process/learnings.md`)
   - `<path>/<docs.retros>` (typically `docs/process/retrospective.md`)

4. **Compare against `knowledge/cross-project-learnings.md`** to identify new entries that haven't been aggregated yet. Avoid duplicating entries already present.

5. **Append new entries** to `knowledge/cross-project-learnings.md`, tagged with:
   - Source project name
   - Date (from retro entry or current date for learnings)
   - Category (if present in the original)

   Format:
   ```markdown
   ## [Category] (from [project-name], [date])
   - [Specific learning or insight]
   ```

6. **Identify cross-cutting patterns** — learnings that appear in multiple projects or that would benefit all projects. Add these to `knowledge/patterns.md` with:
   - The pattern description
   - Which projects it was observed in
   - Whether it should be propagated (and how — skill update, CLAUDE.md update, etc.)

   **Before marking a pattern as needing propagation**, reconcile against what's already been addressed:
   - Read `templates/skills/` and `templates/rules/` — if the fix is already in a template, note it as done
   - Read `docs/process/propagation-log.md` — if it was already pushed to projects, note that
   - Check whether the pattern predates a major tooling adoption (e.g., superpowers) — if the recommended fix is now covered by a shared plugin, flag it as "already addressed by [plugin]" rather than a new action
   - Only flag a pattern as needing propagation if it's absent from templates, absent from the propagation log, and not covered by an installed shared plugin

7. **Commit** the updated `knowledge/` files with message: `knowledge: aggregate learnings from [N] projects`

8. **Summarize** what was aggregated:
   - How many new entries from each project
   - Any cross-cutting patterns identified
   - Recommendations for `/propagate` actions
