---
name: implement
description: Implement an approved plan. Always use this skill when working through a plan — it ensures tasks are tracked, tests are written alongside code, and the user is only interrupted when necessary.
argument-hint: "[plan-file-path]"
user-invocable: true
---
# Implement an Approved Plan

**Always use this skill when implementing a plan.** It keeps work organized, tests written alongside code, and minimizes user interruptions.

## Step 1: Load the Plan

Read the plan file (passed as `$ARGUMENTS`, or find the most recent file in `docs/product/plans/` matching `*plan*`).

Confirm with the user: "I'm about to implement [plan name]. The measurable outcomes are: [list them]. Ready to go?"

## Step 2: Create Task List

Create tasks from the plan's execution strategy (chunks, work packages, or however the plan structures the work). Respect the plan's sequencing decisions — follow its guidance on what runs sequentially vs in parallel.

## Step 3: Work Through Tasks

For each task, in dependency order:

1. Mark as in_progress
2. Read relevant existing files before writing anything
3. Implement the changes
4. **Write tests alongside the code** (not after) — see Testing Standards below
5. Run the tests. If they fail, fix and re-run — don't move on with broken tests
6. Mark as completed
7. After completing a group of related tasks, quick self-check:
  - Did I miss edge cases?
  - Is this the simplest solution?
  - Did I update all places that needed updating?

## Step 4: Automated Testing Gate

Before asking the user for any help (deploys, credentials, manual testing):

- Run ALL automated tests (both new and pre-existing)
- Fix any failures
- Report: "All automated tests pass. Here's what I need from you next: [specific list]"

## Step 5: Handoff for Deployment

Present the user with the exact steps they need to do from the plan's deployment section, in order. Be specific — don't say "deploy", say the exact command or action.

After each user action, run the verification steps from the plan.

## Step 6: Wrap Up

Once all verification passes:

1. Summarize what was built (map back to measurable outcomes)
2. Note anything that was descoped or deferred
3. Ask: "Does this work as expected? Anything clunky or that could be improved?"
4. Check if any learnings should be added to `docs/process/learnings.md`

## Testing Standards

Tests are not an afterthought — they're how we keep the code correct going forward. Aim for these standards:

**Coverage target: ~80% of new code.** Not every line, but the important parts:

- **All key interfaces** — if two modules exchange data (function calls, file formats, API contracts), test the contract from both sides
- **All nontrivial logic** — state classification, data parsing, deduplication, calculations, edge cases
- **All data transformations** — input → output for each processing step

**What NOT to test (diminishing returns):**
- Simple pass-through functions with no logic
- Configuration/constants
- Third-party library behavior

## Principles

- **Use this skill throughout implementation.** Don't abandon the structure partway through — the task list and testing gates exist to catch problems early.
- **Test as you go.** Write tests alongside code, not in a batch at the end.
- **Batch user requests.** Collect everything you need from the user into one ask, not a drip of interruptions.
- **Stay focused.** Don't refactor surrounding code, add comments to unchanged files, or improve things that aren't in the plan.
- **If stuck, say so.** Don't brute-force — explain the blocker and ask for direction.
