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
  - A skill name: `plan`, `implement`, `retro`
  - A rule name: `feedback-loop`
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

3. **Read the current version** from each target project (via absolute filesystem path from `registry.yaml`):
   - Skills: `<project-path>/.claude/skills/{name}/SKILL.md`
   - Rules: `<project-path>/.claude/rules/{name}.md`
   - Settings: `<project-path>/.claude/settings.json`
   - Process docs: `<project-path>/docs/process/*.md`

4. **Compute the diff** and present it to the user:
   - Show what would change in each target project
   - **Note project-specific customizations** that should be preserved (e.g., health-tool's Step 4.5 code review in implement, project-specific deploy skills)
   - Ask: "Which of these changes should I apply? Any customizations to preserve?"

5. **Wait for user approval** before creating any PRs.

6. **For each approved change**, create a PR on the target repo:
   - Use `mcp__github__create_branch` to create a branch named `project-support/propagate-{artifact}-{date}`
   - Use `mcp__github__push_files` to push the updated file(s)
   - Use `mcp__github__create_pull_request` with:
     - Title: `[project-support] Update {artifact} to latest template`
     - Body: Explains what changed, why, and notes any preserved customizations
   - Report the PR URL to the user

7. **Log to `research/applied/`**: Create `research/applied/{YYYY-MM-DD}-propagate-{artifact}.md` with:
   - What was propagated
   - Which projects received PRs
   - PR URLs
   - Any customizations that were preserved

## Principles

- **Never force-update.** Always show the diff and get approval first.
- **Preserve project-specific customizations.** The canonical template is a baseline, not a mandate.
- **One PR per project per artifact.** Don't bundle unrelated changes.
