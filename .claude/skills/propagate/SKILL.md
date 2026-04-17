---
name: propagate
description: Compare a project's Claude setup against templates, show what's changed, and push approved updates via GitHub PRs. Use to bring projects up to date or push specific improvements.
argument-hint: "[artifact-type] [target-project]"
user-invocable: true
---
# Propagate Updates to Projects

Compare projects against `templates/` and push approved updates via GitHub PRs.

## Arguments

- `$ARGUMENTS` can specify:
  - A specific artifact: `retro`, `persist-plan`, `feedback-loop`, `workflow-conventions`, `settings`, `process-docs`
  - `all` — compare everything (default if only a project name is given)
  - A target project name. If omitted, propagate to all projects in `registry.yaml`.

## Steps

1. **Parse arguments** to determine what to compare and which project(s).

2. **Identify the project(s)**:
   - If a project name is given, look it up in `registry.yaml`
   - If not, list all projects from `registry.yaml` and either propagate to all (if an artifact is specified) or ask the user which to update

3. **Ensure freshness** of each target project's main worktree:
   - Run `git -C <path> pull --ff-only` to update to latest origin/main
   - If pull fails (dirty worktree, non-ff), warn the user and ask whether to proceed with stale data

4. **Read the latest templates** from `templates/`:
   - Skills: `templates/skills/*/SKILL.md`
   - Rules: `templates/rules/*.md`
   - Settings: `templates/settings/settings.json`
   - Process docs: `templates/docs/process/*.md`
   - Product docs: `templates/docs/product/*.md`

5. **Read the project's current setup** from its main worktree path:
   - `.claude/skills/` — list all skills, read each SKILL.md
   - `.claude/rules/` — list all rules, read each
   - `.claude/settings.json` — read current plugins and permissions
   - `CLAUDE.md` — read current project guide
   - `docs/process/` and `docs/product/` — check which docs exist

6. **Generate a comparison report**:

   For each artifact, classify as:
   - **Missing** — template exists but project doesn't have it
   - **Outdated** — project has it but differs from template (show diff)
   - **Current** — matches template
   - **Custom** — project has something not in templates (note but don't touch)

   Present the report as a table:

   | Artifact | Status | Details |
   |----------|--------|---------|
   | skills/retro/SKILL.md | Outdated | Template has broader activation triggers |
   | skills/persist-plan/SKILL.md | Missing | Project doesn't have persist-plan skill |
   | rules/feedback-loop.md | Current | Matches template |

7. **Ask the user** which updates to apply. For outdated items, show the diff and highlight project-specific customizations that should be preserved.

8. **Wait for user approval** before creating any PRs.

9. **For each target project**, create a single PR bundling all approved changes:
   - Create a worktree: `git -C <project-path> worktree add -b project-support/propagate-{slug} <project-path>--propagate-{slug}`
   - For files that already exist in the project, diff the template against the project's version to identify project-specific customizations. Apply only the new template additions — do not replace existing content wholesale.
   - For new files, use the template but adjust project-specific values (ticket prefixes, examples) per `registry.yaml`
   - Commit once with a descriptive message covering all changes
   - Push and create PR with `gh pr create --repo <repo>`:
     - Title: `[project-support] {brief description of changes}`
     - Body: Lists each change with rationale, notes preserved customizations
   - Clean up the worktree: `git -C <project-path> worktree remove <worktree-path>`

10. **Hand off to each project's agent for review and merge.** Don't open PRs in the user's browser — the user shouldn't be the reviewer. The project's running agent has the project context and reviews its own PR.

    For each PR:
    - Look up the project's stable_id (from `registry.yaml` or via `mcp__claude-hive__list_peers`)
    - Send a hive message with: the PR URL, what changed, and the merge protocol — review the diff, merge when ready (admin merge OK for trivial template propagation), pull main, run `/reload-plugins` if a new skill or plugin was added (project-level skills are read on demand so a `git pull` is enough; only `/reload-plugins` if `enabledPlugins` changed)
    - Stagger sends ~5s apart per the broadcast rule
    - Don't restart sessions. Each agent stays in place and picks up changes via the merge.

    The agent replies when merged + pulled. The user only gets pulled in if the agent flags a problem.

11. **Log to `docs/process/propagation-log.md`**: Append an entry with:
    ```markdown
    ## YYYY-MM-DD — [artifact] → [projects]
    - **Changes:** [what was propagated]
    - **PRs:** [PR URLs]
    - **Preserved:** [any project-specific customizations kept]
    ```
    Create the file if it doesn't exist (header: `# Propagation Log`).

12. **Commit** the propagation log with message: `docs: log propagation of [artifact] to [projects]`

## Principles

- **Never force-update.** Always show the comparison report, get approval first.
- **Preserve project-specific customizations.** The canonical template is a baseline, not a mandate. Each project has its own tools, processes, and conventions — build on what's there.
- **Report but don't touch custom artifacts.** If a project has skills/rules not in templates, note them but leave them alone.
- **One PR per project.** Bundle related changes into a single commit and PR per project.
- **Use worktrees.** Always create a temporary worktree for making changes — never edit the main worktree directly.
