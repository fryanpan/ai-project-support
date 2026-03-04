# Autonomous-First Workflow Design

**Date:** 2026-03-04

## Goal

Streamline the development workflow skills so agents make autonomous decisions when safe, and only ask humans when decisions are hard to reverse or high-risk. This applies equally to human-led and fully automated (ticket agent) scenarios.

## Decision Framework

Inspired by the product-engineer repo's reversible/irreversible split:

**Reversible — agent decides autonomously, logs to `decisions.md`:**
- File structure, naming conventions
- Implementation approach selection
- Package and dependency choices
- Test strategy and code organization
- Error handling patterns
- DB schema changes (non-public APIs)
- API contract changes (non-public APIs)

**Irreversible — batch questions and ask:**
- Data deletion or loss scenarios
- Force pushes or destructive git operations
- Architectural decisions affecting multiple systems
- External service integrations with billing/security implications

**Note:** Projects with public APIs or mature schemas where users depend on specific contracts should override the DB/API defaults to require approval. The template provides the permissive default; projects tighten as needed.

## Changes

### 1. `templates/rules/workflow-conventions.md`

Add two new sections:

**Decision Framework** — the criteria above, with the rule: "If easy to change later and low-risk, make your best call and document it in `decisions.md`. If hard to reverse or high-risk, batch all questions and present together."

**Superpowers Overrides** — behavioral modifications to plugin skills:
- **Brainstorming**: All clarifying questions at once (not one-at-a-time). Make reversible design decisions autonomously. Present full design in one pass. Only pause for irreversible decisions.
- **Executing Plans**: Skip feedback checkpoints between batches. Only stop if blocked or facing irreversible decision. Verification gates still enforced.
- **Finishing Branch**: Default to creating PR without asking. Only prompt if tests fail or target branch is ambiguous.
- **Retro**: Run autonomously if no human present. In human-led mode, ask once for feedback, not multiple rounds.

### 2. `templates/skills/retro/SKILL.md`

Add autonomous mode support:
- Detect whether session is human-led or autonomous
- If autonomous: analyze transcript, log findings, execute low-risk improvements without asking
- If human-led: ask for feedback (one prompt, not multiple rounds), then propose and execute approved actions

### 3. `templates/docs/process/process.md`

Update to reference decision framework in the workflow table and feedback loops section.

## What Stays The Same

- TDD, systematic-debugging, verification-before-completion — quality discipline unchanged
- Code review dispatch — already autonomous
- The reversible/irreversible framework applies identically in all modes; only the communication channel changes

## Decisions Made

| Decision | Rationale | Alternatives |
|----------|-----------|--------------|
| Override superpowers via workflow-conventions rule, don't modify plugin | Keeps changes in project templates; superpowers plugin stays generic | Modify plugin directly (rejected: affects all users) |
| DB schema + API contracts default to reversible | Most projects have non-public APIs; mature projects override | Default to irreversible (rejected: too conservative for most projects) |
| Single decision framework for human-led + autonomous | Same criteria regardless of who's driving; only communication channel differs | Separate frameworks per mode (rejected: unnecessary complexity) |
