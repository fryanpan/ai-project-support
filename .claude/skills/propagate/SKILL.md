---
name: propagate
description: Push skill, rule, or doc pattern updates from templates/ to registered projects via GitHub PRs. Compares canonical versions against what each project has and creates PRs for the differences.
argument-hint: "<artifact-type> [target-project]"
user-invocable: true
---
# Propagate Updates to Projects

Push updates from `templates/` to registered projects via GitHub PRs.

## Arguments

- `$ARGUMENTS` should specify what to propagate:
  - A skill name: `retro`, `persist-plan`
  - A rule name: `feedback-loop`, `workflow-conventions`
  - A doc type: `settings`, `process-docs`
  - `all` — compare everything
- Optionally followed by a target project name. If omitted, propagate to all projects in `registry.yaml`.

## Steps

1. **Parse arguments** to determine what to propagate and to which project(s).

2. **Read the canonical version** from `templates/`:
   - Skills: `templates/skills/{name}/SKILL.md`
   - Rules: `templates/rules/{name}.md`
   - Settings: `templates/settings/settings.json`
   - Process docs: `templates/docs/process/*.md`

3. **Ensure freshness** of each target project's main worktree:
   - Run `git -C <path> pull --ff-only` to update to latest origin/main
   - If pull fails (dirty worktree, non-ff), warn the user and ask whether to proceed with stale data

4. **Read the current version** from each target project (via absolute filesystem path from `registry.yaml`):
   - Skills: `<project-path>/.claude/skills/{name}/SKILL.md`
   - Rules: `<project-path>/.claude/rules/{name}.md`
   - Settings: `<project-path>/.claude/settings.json`
   - Process docs: `<project-path>/docs/process/*.md`

5. **Compute the diff** and present it to the user:
   - Show what would change in each target project
   - **Note project-specific customizations** that should be preserved (e.g., project-specific rules, domain skills, custom workflow-conventions)
   - Ask: "Which of these changes should I apply? Any customizations to preserve?"

6. **Wait for user approval** before creating any PRs.

7. **For each target project**, create a single PR bundling all approved changes:
   - Create a worktree: `git -C <project-path> worktree add -b project-support/propagate-{slug} <project-path>--propagate-{slug}`
   - For files that already exist in the project, diff the template against the project's version to identify project-specific customizations. Apply only the new template additions — do not replace existing content wholesale.
   - For new files, use the template but adjust project-specific values (ticket prefixes, examples) per `registry.yaml`
   - Commit once with a descriptive message covering all changes
   - Push and create PR with `gh pr create --repo <repo>`:
     - Title: `[project-support] {brief description of changes}`
     - Body: Lists each change with rationale, notes preserved customizations
   - Clean up the worktree: `git -C <project-path> worktree remove <worktree-path>`

8. **Open all PRs for review**: After all PRs are created, open each PR URL in the browser using `open <url>` so the user can review them.

9. **Log to `research/applied/`**: Create `research/applied/{YYYY-MM-DD}-propagate-{artifact}.md` with:
   - What was propagated
   - Which projects received PRs
   - PR URLs
   - Any customizations that were preserved

10. **Commit** the applied log with message: `docs: log propagation of [artifact] to [projects]`

## Principles

- **Never force-update.** Always show the diff and get approval first.
- **Preserve project-specific customizations.** The canonical template is a baseline, not a mandate.
- **One PR per project.** Bundle related changes into a single commit and PR per project.
- **Use worktrees.** Always create a temporary worktree for making changes — never edit the main worktree directly.
