# AI Project Support (Metaproject)

It takes real work to get a project set up to work smoothly with AI coding tools — the right `CLAUDE.md`, skills, rules, settings, feedback loops. Multiply that by several projects and it's a lot of overhead.

This repo streamlines that work. It maintains shared templates and propagates improvements across all your projects via GitHub PRs, making it easier to start new projects or join existing ones. The target user is ultimately someone non-technical, or even an automated process run mostly by an agent.

## What It Does

- **Start new projects** — scaffold a repo with GitHub, project tracking, and full Claude Code setup in one step
- **Join existing projects** — read what's already there (tools, conventions, repo structure), compare against templates, and propose improvements that build on it
- **Propagate** skill/rule/template improvements across all your projects
- **Aggregate** learnings and retro insights into a central knowledge base
- **Research** a pain point or desired outcome — finds tools and techniques that address it

See [docs/product/vision.md](docs/product/vision.md) for the full vision and [docs/product/use-cases.md](docs/product/use-cases.md) for detailed use cases.

## Getting Started

1. **Fork this repo** and clone it:
   ```bash
   git clone git@github.com:your-username/ai-project-support.git ~/dev/project-support
   ```

2. **Set up your registry** — copy the example and fill in your projects:
   ```bash
   cp registry.yaml.example registry.yaml
   ```

3. **Configure Linear (optional)** — update the `## Linear` section in `CLAUDE.md` with your team info.

4. **Start using skills** — open in [Conductor](https://conductor.build) or Claude Code CLI and run `/aggregate`, `/propagate`, `/new-project`, etc.

## Private Files

Some files are gitignored because they contain project-specific data that's personal to you.

| File | Contains | Example |
|------|----------|---------|
| `registry.yaml` | Your project list, team metadata, Linear/Notion IDs | `registry.yaml.example` |
| `docs/process/retrospective.md` | Session retros (auto-generated, project-specific) | `templates/docs/process/retrospective.md` |
| `docs/process/propagation-log.md` | Propagation audit log with PR URLs | — |

### Worktree Setup

When using [Conductor](https://conductor.build) or git worktrees, private files don't carry over automatically. Run the setup script in each new worktree to symlink them from your main worktree:

```bash
./scripts/setup-private.sh
```

This creates symlinks to `~/dev/project-support/` so all worktrees share the same private data. Edit `MAIN_WORKTREE` in the script if your main worktree is elsewhere.

## Structure

```
templates/        Canonical versions of shared skills, rules, docs, settings
knowledge/        Aggregated cross-project learnings and patterns
research/         Research findings on agent techniques and tools
docs/             This project's own process docs and product design
scripts/          Utility scripts (worktree setup, etc.)
.claude/skills/   Skills that power the /slash commands
.claude/rules/    Rules that guide agent behavior
```

## License

[MIT-0](LICENSE) — do whatever you want with this. Attribution appreciated but not required.
