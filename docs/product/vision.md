# Vision

## Problem

Managing multiple projects with Claude Code means duplicating skills, rules, settings, and learnings across repos. When a workflow improvement is discovered in one project, it doesn't automatically flow to others. There's no systematic way to research new techniques and apply them.

Beyond personal projects, there's also an opportunity to help other teams adopt Claude Code workflows — but each team has different tools, conventions, and skill levels. Setting up a team well requires understanding their stack, integrating with their existing tools, and creating feedback loops so gains compound.

## Goals

1. **Cross-project management** — Maintain shared templates for skills, rules, and settings. Propagate improvements across personal projects via PRs.

2. **Knowledge aggregation** — Pull learnings and retro insights from all projects into a central knowledge base. Identify cross-cutting patterns.

3. **Research** — Stay current on Claude Code, Codex, and community tools (GSD, Autoclaude, Superpowers, aider, cursor, etc.). Evaluate new techniques and apply them.

4. **Project scaffolding** — Spin up new projects with full GitHub, Linear, and Claude Code setup in one step. Keep existing projects up to date with latest templates.

5. **Advisory engagements** — Help external teams adopt Claude Code workflows. Analyze their project, set up config tailored to their stack and tools, establish feedback loops, and onboard team members.

## Non-Goals

- Not a monorepo — projects remain independent repos
- Not a CI/CD system — each project manages its own deployment
- Not a replacement for project-specific skills (e.g., health-tool's `/analyze`)
