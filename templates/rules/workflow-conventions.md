---
alwaysApply: true
---

# Workflow Conventions

Project-specific conventions that guide how superpowers plugin skills behave in this project.

## Planning

- Plans MUST be written to `docs/product/plans/<prefix>-plan.md`
  - `<prefix>` is the ticket number (e.g., `BIK-12`) or sprint number (e.g., `sprint-3`)
  - Ask the user which prefix to use if unclear
- If a plan exists in `.claude/plans/` but not in `docs/product/plans/`, persist it using `/persist-plan`
- Plans should include:
  - Measurable outcomes (concrete yes/no statements)
  - Key workflows (mermaid flowcharts)
  - Alternatives evaluation (table: Effort, Risk, Usability, Impact) — propose 2-3 fundamentally different approaches, not variations
  - System design with component diagram (mermaid) and interfaces table
  - Execution strategy: chunking, sequencing vs parallelism, risk notes
  - Testing & deployment strategy

## Execution Strategy

After planning, choose an execution approach. Present these options to the user:

| Approach | When to use | How it works |
|----------|-------------|--------------|
| **Executing Plans** (default) | Most tasks. You want human checkpoints between batches. | `superpowers:executing-plans` — creates a worktree, executes in batches of 3 tasks, pauses for review between batches. |
| **Subagent-Driven Development** | Tasks are independent. You want fast iteration with automated review. | `superpowers:subagent-driven-development` — stays in current session, dispatches a fresh subagent per task with two-stage review (spec compliance, then code quality). |
| **Agent Team** (experimental) | Highly parallel work where 3+ tasks can run simultaneously with no shared state. | `TeamCreate` + spawn teammates — named agents coordinate via task list and messages, work in true parallel. Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` env var. |

**Decision flow:**
1. Are tasks mostly independent with no shared state? If no → **Executing Plans**
2. Can 3+ tasks genuinely run in parallel? If yes → **Agent Team**
3. Otherwise → **Subagent-Driven Development** (sequential but automated)

If unsure, default to **Executing Plans** — it's the most predictable.

## Implementation

- Read relevant existing files before writing anything
- Write tests alongside code, not after
- Coverage target: ~80% of new code
- Test all key interfaces, nontrivial logic, and data transformations
- Do NOT test: simple pass-throughs, configuration/constants, third-party library behavior
- Run ALL tests (new + existing) before requesting user help
- Stay focused on the plan — do not refactor unrelated code
- If stuck, say so — don't brute-force

## Code Review

- After tests pass, run a code review before presenting results to the user
- Fix issues found by the reviewer before handoff

## Commit Discipline

Commit early and often to create an incremental record. Key checkpoints:

- **After planning**: Once the plan is written to `docs/product/plans/`, commit it
- **After implementation**: Before requesting review, organize work into logical, digestible commits — each commit should represent one coherent change (a feature, a test suite, a refactor). Don't lump everything into one giant commit
- **After code review**: Commit review fixes as separate commit(s) so the review trail is visible
- **After retro/learnings updates**: Commit changes to `docs/process/` files

Use descriptive commit messages that explain *why*, not just *what*.

## Diagrams

- Use mermaid for all diagrams (architecture, workflows, dependencies)
