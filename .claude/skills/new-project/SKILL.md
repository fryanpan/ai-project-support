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

2. **Create GitHub repo** (use `gh` CLI — the GitHub MCP plugin is unreliable per `docs/process/learnings.md`):
   - Run: `gh repo create <owner>/<project-name> --<visibility> --description "<one-line>" --clone=false`
   - Note the repo URL (`https://github.com/<owner>/<project-name>`) for later

3. **Set up Linear** (via the Linear MCP plugin if authenticated; tool names vary by install):
   - If using an existing team: note the team ID from the user or the Linear UI
   - If creating a new Linear project: use whichever `create_project` tool is available on the Linear MCP, or ask the user to create it manually in the Linear UI and paste the team key back
   - Record the Linear project name + team key — you'll need them in step 6 when you register the project

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

5. **Push scaffold to GitHub** (use local `git`, not the GitHub MCP):
   - Clone the empty repo locally to its permanent home: `git clone git@github.com:<owner>/<project-name>.git ~/dev/<project-name>`
   - Write all scaffolded files into the local clone using the customized template content from step 4
   - `git add -A && git commit -m "Initial project scaffold from ai-project-support templates" && git push origin main`
   - The local clone at `~/dev/<project-name>` becomes the permanent home for the project — subsequent steps and future sessions read from this path.

6. **Register the project** — invoke the `/add-project` skill to append the new project to `registry.yaml`. That skill handles path verification, append, and the "do not commit" guidance. All inputs (name, local path, GitHub repo, Linear team) are already gathered from steps 1–3.

7. **Print setup instructions** for the user:
   ```
   Project created! Local clone at ~/dev/{project-name}, registered in registry.yaml.

   Next steps:
   1. cd ~/dev/{project-name}
   2. Start a Claude Code session in the repo so the conductor can reach it via claude-hive
   3. Start planning your first feature (use plan mode for non-trivial work)
   ```

## Principles

- **Fast and complete.** The user should go from zero to a working project in one invocation.
- **Templates are the source of truth.** Always read from `templates/`, never hardcode content in this skill.
- **Ask, don't assume.** Get the project name, stack, and team preference from the user before creating anything.
