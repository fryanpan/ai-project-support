# Vision

## Problem

Managing multiple projects with Claude Code means duplicating skills, rules, settings, and learnings across repos. When a workflow improvement is discovered in one project, it doesn't automatically flow to others. There's no systematic way to research new techniques and apply them.

Starting a new project from scratch — repo, tooling, Claude config, docs — is a lot of setup before any real work begins. And joining an existing project is even harder: you need to understand what's already there (tools, processes, repo structure, team conventions) before you can help effectively.

The target user for this repo is ultimately someone non-technical, or even an automated process run mostly by an agent. The metaproject should be operable by someone who thinks in terms of problems and outcomes, not frameworks and CLIs.

## Goals

1. **Cross-project management** — Maintain shared templates for skills, rules, and settings. Propagate improvements across projects via PRs.

2. **Knowledge aggregation** — Pull learnings and retro insights from all projects into a central knowledge base. Identify cross-cutting patterns.

3. **Research** — Stay current on Claude Code, Codex, and community tools (GSD, Autoclaude, Superpowers, aider, cursor, etc.). Evaluate new techniques and apply them.

4. **Start new projects** — Spin up new projects with full GitHub, Linear, and Claude Code setup in one step. Works for any project — personal tools, team codebases, collaborator ideas.

5. **Join and improve existing projects** — Read an existing project's setup, understand what's already there (their tools, conventions, repo structure), and propose improvements that build on it rather than replacing it. Respect what the team has chosen; adapt templates to fit.

6. **Non-technical accessibility** — The barrier between "I have an idea" and "there's a working repo with Claude ready to help me build it" should be as low as possible. Someone with domain expertise but no daily programming practice should be able to use this.

## Non-Goals

- Not a monorepo — projects remain independent repos
- Not a CI/CD system — each project manages its own deployment
- Not a replacement for project-specific skills (e.g., a project's own `/analyze`)
