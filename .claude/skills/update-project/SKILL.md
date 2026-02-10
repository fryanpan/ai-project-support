---
name: update-project
description: Compare an existing project's Claude setup against the latest templates and propose PRs to bring it up to date. Use when templates have been improved and you want to propagate the improvements.
argument-hint: "<project-name>"
user-invocable: true
---
# Update an Existing Project

Compare a project's current Claude setup (skills, rules, settings, doc structure) against the latest templates and offer to bring it up to date.

## Steps

1. **Identify the project**:
   - If `$ARGUMENTS` is provided, look it up in `registry.yaml`
   - If not, list all projects from `registry.yaml` and ask the user which one to update

2. **Read the project's current setup** from its main worktree path:
   - `.claude/skills/` — list all skills, read each SKILL.md
   - `.claude/rules/` — list all rules, read each
   - `.claude/settings.json` — read current plugins and permissions
   - `CLAUDE.md` — read current project guide
   - `docs/process/` — check which process docs exist
   - `docs/product/` — check which product docs exist

3. **Read the latest templates** from `templates/`:
   - `templates/skills/*/SKILL.md`
   - `templates/rules/*.md`
   - `templates/settings/settings.json`
   - `templates/docs/process/*.md`
   - `templates/docs/product/*.md`

4. **Generate a comparison report**:

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
   | docs/process/process.md | Missing | No process.md in project |

5. **Ask the user** which updates to apply. For outdated items, show the diff and ask if project-specific customizations should be preserved.

6. **Create PRs** for approved updates using `/propagate` workflow:
   - Branch: `project-support/update-{project}-{date}`
   - One PR per project with all approved changes bundled
   - PR body lists each change with rationale

7. **Update `registry.yaml`** if any project metadata changed (new docs paths, etc.)

## Principles

- **Respect project autonomy.** Show diffs, get approval, preserve customizations.
- **Bundle changes into one PR.** Don't create separate PRs for each file — that's noisy.
- **Report but don't touch custom artifacts.** If a project has skills/rules not in templates, note them but leave them alone.
