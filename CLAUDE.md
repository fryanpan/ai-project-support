# Project: Project Support (Metaproject)

## Overview

Cross-project management tool that reviews, improves, and scaffolds other projects. Does not build software directly — it reads from other project repos and proposes changes via GitHub PRs.

## How It Works

### Project Registry
`registry.yaml` maps each managed project to its local path, GitHub repo, and Linear team. The metaproject reads from main worktrees (`~/dev/{project}`) using absolute filesystem paths.

**Before reading from a project**, ensure freshness: `git -C <path> pull --ff-only` to update to latest origin/main. If pull fails (dirty worktree or diverged history), investigate before reading.

### Cross-Project Changes
Never edit files in other project repos directly. Always propose changes via GitHub PRs using `mcp__github__push_files` + `mcp__github__create_pull_request`, or `gh pr create --repo <repo>`.

### Worktree Interaction
Each project has 2-5 active Conductor worktrees. The metaproject always reads from the main worktree at `~/dev/{project}`. Feature branch worktrees are not read — they may have uncommitted or in-progress work.

## Skills

| Skill | Purpose |
|-------|---------|
| `/aggregate` | Pull learnings and retros from all registered projects into `knowledge/` |
| `/research` | Web research on Claude Code, Codex, agent workflow tools, HN discourse |
| `/propagate` | Push skill/rule/doc updates to projects via PRs |
| `/new-project` | Scaffold a new project with GitHub repo, Linear project, `.claude/`, and `docs/` |
| `/update-project` | Compare an existing project against templates, propose PRs for updates |
| `/retro` | Meta-level retrospective on this project's sessions |

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `templates/` | Canonical versions of shared skills, rules, doc templates, settings |
| `knowledge/` | Aggregated cross-project learnings and patterns |
| `research/` | Research findings on agent techniques and tools |
| `docs/process/` | This project's own learnings, retros, and process docs |

## Conventions

### Before Making Changes
- Read `registry.yaml` to understand which projects are managed
- Check `knowledge/cross-project-learnings.md` for known patterns
- Check `docs/process/learnings.md` for metaproject-specific gotchas

### After Making Changes
- If a template was updated, consider running `/propagate` to push it to projects
- Log non-obvious decisions in `docs/process/learnings.md`

### Code Style
- Templates should be generic — no project-specific values hardcoded
- Use `{{placeholder}}` syntax in `.tmpl` files for values that vary per project
- Keep skills focused — one skill per workflow, not monolithic multi-purpose skills

## Linear
- Team: Project Support (PS)
- Team ID: 78e39047-e173-4766-ae85-da11ff278050

@docs/process/learnings.md
