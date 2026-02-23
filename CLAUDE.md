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
| `/research` | Research a pain point or desired outcome — finds tools, techniques, and approaches |
| `/propagate` | Compare projects against templates, push approved updates via PRs |
| `/new-project` | Scaffold a new project with GitHub repo, Linear project, `.claude/`, and `docs/` |
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

### Privacy in Commits and PRs
The names and details of managed projects are private. When writing commit messages or PR descriptions for this repo:
- Do NOT include project names (e.g., use `registry: add new project`, not `registry: add personal-crm`)
- Do NOT describe what a new project does or who it's for
- PR descriptions should only cover what changed in *this* repo (skills, templates, scripts, hooks), not the project that triggered the work

### Code Style
- Templates should be generic — no project-specific values hardcoded
- Use `{{placeholder}}` syntax in `.tmpl` files for values that vary per project
- Keep skills focused — one skill per workflow, not monolithic multi-purpose skills

## Private Files

Some files are gitignored because they contain project-specific data (project names, team members, IDs). These are symlinked from the main worktree in Conductor worktrees.

| File | Contains |
|------|----------|
| `registry.yaml` | Project list, team metadata, Linear/Notion IDs |
| `docs/process/retrospective.md` | Session retros (auto-generated, project-specific) |
| `research/applied/*` | Propagation logs with specific PR URLs |

**After creating a worktree**, run `./scripts/setup-private.sh` to symlink these from the main worktree.

**One-time setup after a fresh clone** — enable the git hook that auto-runs `setup-private.sh` on worktree creation:
```bash
git config core.hooksPath .githooks
```

See `registry.yaml.example` for the registry schema.

## Linear
- Team: {{team_name}} ({{team_key}})
- Team ID: {{team_id}}

@docs/process/learnings.md
