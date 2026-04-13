# Project: AI Project Support (Conductor + Metaproject)

## Overview

Cross-project conductor and management tool. Two roles in one:

1. **Conductor** — handles DMs, routes work to the right project, tracks tasks across all managed products, and coordinates the autonomous agent system.
2. **Metaproject** — reviews, improves, and scaffolds other projects. Reads from project repos and proposes changes via GitHub PRs.

## How It Works

### Project Registry
`registry.yaml` maps each managed project to its local path, GitHub repo, and Linear team. The metaproject reads from main worktrees (`~/dev/{project}`) using absolute filesystem paths.

**Before reading from a project**, ensure freshness: `git -C <path> pull --ff-only` to update to latest origin/main. If pull fails (dirty worktree or diverged history), investigate before reading.

### Cross-Project Changes
Never edit files in other project repos directly. Always propose changes via GitHub PRs using `gh pr create --repo <repo>`. The GitHub MCP plugin is unreliable for private repos and new repos — see `docs/process/learnings.md`.

### Worktree Interaction
Each project has 2-5 active Conductor worktrees. The metaproject always reads from the main worktree at `~/dev/{project}`. Feature branch worktrees are not read — they may have uncommitted or in-progress work.

## Skills

### Conductor / Registry
| Skill | Purpose |
|-------|---------|
| `/conductor` | Coordinate peer Claude Code sessions across managed products via claude-hive |
| `/add-project` | Append an existing repo to `registry.yaml` |
| `/new-project` | Scaffold a new project from scratch (GitHub repo, Linear project, `.claude/`, then registers via `/add-project`) |

### Agent Operations (used by peer sessions working on tickets)
| Skill | Purpose |
|-------|---------|
| `/ticket-agent` | Decision framework for autonomous ticket work in a peer session; reports to the conductor via claude-hive |
| `/ship-it` | Post-implementation pipeline: code review, PR, CI monitoring, Copilot review |

### Cross-Project
| Skill | Purpose |
|-------|---------|
| `/aggregate` | Pull learnings and retros from all registered projects, identify cross-cutting patterns |
| `/propagate` | Compare projects against templates, push approved updates via PRs |
| `/research` | Research a pain point or desired outcome |
| `/retro` | Meta-level retrospective on this project's sessions |
| `/persist-plan` | Persist an internal plan to `docs/product/plans/` |

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `templates/` | Canonical versions of shared skills, rules, doc templates, settings |
| `research/` | Research findings on agent techniques and tools |
| `docs/process/` | This project's own learnings, retros, process docs, and cross-project learnings |

## Conventions

### Before Making Changes
- Read `registry.yaml` to understand which projects are managed
- Check `docs/process/aggregation-log.md` for known patterns
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
| `docs/process/propagation-log.md` | Propagation audit log with PR URLs (gitignored) |

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
