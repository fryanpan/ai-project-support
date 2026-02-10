---
name: new-project
description: Scaffold a new project with GitHub repo, Linear project, Claude Code setup (.claude/ skills, rules, settings), and documentation structure. Gets a new project from zero to ready-for-development in one step.
user-invocable: true
---
# Scaffold a New Project

Create a fully set up project from scratch — GitHub repo, Linear project, Claude Code configuration, and documentation structure.

## Steps

1. **Gather project info** — ask the user for:
   - **Project name** (will be used for repo name, directory name, Linear project)
   - **Description** (one-line summary)
   - **Language/stack** (e.g., Python, Swift/iOS, TypeScript/Node, etc.)
   - **Linear team** — use existing team or create a new one? List available teams from `mcp__linear-server__list_teams`
   - **Visibility** — public or private GitHub repo?

2. **Create GitHub repo**:
   - Use `mcp__github__create_repository` with the project name and description
   - Set visibility as specified
   - Note the repo URL for later

3. **Set up Linear**:
   - If using existing team: note the team ID
   - If creating new team: use `mcp__linear-server__create_project` (or ask user to create the team manually if the API doesn't support team creation)
   - Create initial milestone or project for the first sprint

4. **Scaffold files from templates**:

   Read each template from `templates/` and customize:

   - **`CLAUDE.md`** — from `templates/docs/CLAUDE.md.tmpl`, fill in `{{project_name}}`, `{{project_description}}`, `{{development_setup}}` based on the language/stack
   - **`.claude/skills/retro/SKILL.md`** — copy from `templates/skills/retro/SKILL.md`
   - **`.claude/skills/persist-plan/SKILL.md`** — copy from `templates/skills/persist-plan/SKILL.md`
   - **`.claude/rules/feedback-loop.md`** — copy from `templates/rules/feedback-loop.md`
   - **`.claude/rules/workflow-conventions.md`** — copy from `templates/rules/workflow-conventions.md`
   - **`.claude/settings.json`** — from `templates/settings/settings.json`, add language-specific plugins if applicable (e.g., `pyright-lsp` for Python, `typescript-lsp` for TS)
   - **`docs/process/learnings.md`** — from template
   - **`docs/process/retrospective.md`** — from template
   - **`docs/process/process.md`** — from template
   - **`docs/product/decisions.md`** — from template
   - **`docs/product/vision.md`** — from template, fill in placeholders

5. **Push scaffold to GitHub**:
   - Use `mcp__github__push_files` to push all scaffolded files to the `main` branch
   - Commit message: "Initial project scaffold from project-support templates"

6. **Add to registry**:
   - Append the new project to `registry.yaml` with path, repo, and Linear info
   - Commit this change to the metaproject

7. **Print setup instructions** for the user:
   ```
   Project created! Next steps:
   1. Clone: git clone git@github.com:fryanpan/{project-name}.git ~/dev/{project-name}
   2. Open in Conductor to start a workspace
   3. Start planning your first feature (use plan mode for non-trivial work)
   ```

## Principles

- **Fast and complete.** The user should go from zero to a working project in one invocation.
- **Templates are the source of truth.** Always read from `templates/`, never hardcode content in this skill.
- **Ask, don't assume.** Get the project name, stack, and team preference from the user before creating anything.
