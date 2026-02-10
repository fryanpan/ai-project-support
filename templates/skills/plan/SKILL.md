---
name: plan
description: Plan a feature or sprint before implementing. Use when starting a new sprint or feature or when the user asks to build something non-trivial. If the user dives into implementation of something complex without a plan, gently suggest running /plan first — good plans let Claude work faster and more independently.
user-invocable: true
---

# Plan

Create a plan that lets Claude divide the work into independent subagents, respect dependencies, and complete most or all of the implementation without human intervention. The goal is **just enough planning to let Claude move quickly** — no more.

## When to Use This

- Starting a new sprint or feature
- The user describes something that touches 3+ files or has multiple use cases
- **If the user jumps into building something complex without a plan**, pause and suggest: "This seems like it'd benefit from a quick plan so I can work through it independently. Want to run `/plan` first?"

## Phase 1: Clarify Outcomes

Restate what you understand the user wants. Then **ask clarifying questions** for anything ambiguous:

- What does "done" look like? How would you verify each outcome?
- What's the scope? (platforms, users, what's excluded)
- What matters most — speed to impact, measurability, low effort?
- Constraints? (timeline, tech, dependencies on other people)

Write outcomes as concrete yes/no statements: "By end of sprint, X is true."

**Do NOT proceed until outcomes are agreed.** Ask rather than assume.

## Phase 2: Map Workflows

For each outcome, sketch a mermaid flowchart of the user-facing workflow:
- What triggers it (user action)
- What processes it (system components)
- What it produces (outputs, side effects)

Ask: **"Does this match how you'd actually use this? What am I getting wrong?"**

## Phase 3: Propose Alternatives (do not skip)

For **each use case**, propose **2-3 wildly different approaches**. Not variations — fundamentally different strategies:
- Low-effort hack vs proper engineered system
- Building on a tool the user already uses vs something new
- Manual with automation assist vs fully automated
- Conversational vs dedicated UI vs CLI

Evaluate each in a table:

| Criterion | What to assess |
|-----------|---------------|
| **Effort** | How much to build? (S/M/L) |
| **Risk** | What could go wrong? Dependencies? Unknowns? |
| **Usability** | How easy day-to-day? Will the user stick with it? |
| **Impact** | How directly does it satisfy the outcome? |

Ask the user:
- "Which feels closest to what you want?"
- "Ideas for approaches I haven't considered?"
- "What tradeoffs matter most this sprint?"

**Wait for user's response before choosing.** Do not default-select.

## Phase 4: Write the Plan

Once approaches are chosen, write to `docs/product/plans/<prefix>-plan.md` where `<prefix>` is either the sprint number (e.g., `sprint-3`) or ticket number (e.g., `HT-42`). Ask the user which prefix to use if unclear.

The plan should give Claude everything it needs to produce a high-quality implementation as efficiently as possible. **There is no single right structure** — adapt the plan to the problem.

### Plan structure

1. **Measurable Outcomes** — agreed list from Phase 1

2. **Key Workflows** — mermaid flowcharts from Phase 2

3. **Use Cases** — chosen approach per use case, with one-line rationale for why this alternative was picked

4. **System Design:**
   - Component diagram (mermaid) — existing vs new vs modified
   - Key interfaces table — what connects to what, data format, contract each side must honor
   - All files to create/modify in one table (file, action, purpose)

5. **Execution Strategy** — this is the critical section. Figure out the most efficient way to produce a correct implementation. Consider:

   **Chunking:** Break the work into logical chunks. Chunks might be by feature, by layer, by file group, or by dependency tier — whatever makes the most sense for this problem. For each chunk:
   - What it produces (files created/modified, interfaces implemented)
   - Testable acceptance criterion
   - What it depends on (other chunks, shared interfaces, fixture data)

   **Sequencing & Parallelism:** Not all work benefits from parallelization. Decide based on the problem:
   - **Sequential** when chunks are tightly coupled, share evolving state, or when getting chunk A right informs how to build chunk B
   - **Parallel** when chunks are truly independent with well-defined interfaces between them — define those interfaces up front so parallel work doesn't conflict
   - **Hybrid** — some chunks sequential, some parallel. Show the dependency structure (mermaid DAG or simple list)

   **Risk & complexity notes:** Flag anything that's tricky, underspecified, or likely to need iteration. These chunks should be done early (not last) so surprises surface when there's time to adapt.

6. **Testing & Deployment:**
   - **Automated** (Claude runs independently): unit tests with fixture data, integration tests, syntax checks. List exactly what tests to write and what they verify.
   - **Handoff** (user does): exact commands/actions, in order. Batch these — one interruption, not many.
   - **Manual review** (user verifies): what the user checks after deployment.

### What makes a good plan for Claude execution

- **Interfaces defined before implementation.** If two chunks share a data format, the plan specifies that format. This is essential for parallel work but also prevents rework in sequential flows.
- **Each chunk is testable.** Claude should be able to build a chunk, run tests, and confirm it works — without needing everything else to be done first.
- **Fixture data specified.** For chunks that consume external data (APIs, files), the plan describes the fixture/mock format so tests don't need live services.
- **Minimal ambiguity.** Design decisions belong in the plan, not discovered during implementation. Flag unknowns explicitly rather than leaving them implicit.
- **Right-sized chunks.** Too granular = overhead and lost context. Too coarse = no clear progress signal. Aim for chunks that take 10-30 minutes each.

## Phase 5: Review

Present the plan and ask:
- "Does anything feel over-engineered or under-scoped?"
- "Is it clear when I'll need your help vs when I can work independently?"
- "Ready to implement?"

## Principles

- **Just enough planning.** The plan should remove ambiguity and enable parallelism — not document every line of code.
- **Ask about existing workflows first.** Build on what the user already does.
- **Prefer low-friction over comprehensive.** A simple path they'll use beats a system they won't.
- **Diagrams over text walls.** Mermaid for workflows, components, dependencies.
- **Maximize Claude autonomy.** Every hour of planning that removes a blocking question during implementation is worth it.
