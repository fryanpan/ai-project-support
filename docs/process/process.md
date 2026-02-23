# How We Work

## This is a Metaproject

Project-support doesn't build software directly. It manages, reviews, and improves other projects.

## Core Workflows

### Cross-Project Review
1. Run `/aggregate` to pull learnings from all projects
2. Review `knowledge/cross-project-learnings.md` for patterns
3. Use `/propagate` to push improvements to projects via PRs

### Research
1. Run `/research` with a topic or use the default watchlist
2. Review findings in `research/`
3. When findings are actionable, use `/propagate` to apply them

### New Projects
1. Run `/new-project` to scaffold a new project with GitHub, Linear, and Claude setup
2. The project is added to `registry.yaml` automatically

### Updating Existing Projects
1. Run `/propagate all <project-name>` to compare against latest templates
2. Review the comparison report and approve which updates to apply
3. PRs are created on the target repo

## Session Continuity
- Reference `registry.yaml` for the list of managed projects
- Read `knowledge/cross-project-learnings.md` for aggregated insights
- Read `research/` for current research findings
- Check `docs/process/learnings.md` for metaproject-specific gotchas
