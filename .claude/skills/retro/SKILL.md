---
name: retro
user-invocable: true
description: Run a meta-level retrospective on metaproject sessions. Analyzes transcript, identifies patterns in cross-project work, and captures learnings. Only use when the user explicitly invokes /retro or after completing a major cross-project task.
---
# Meta-Level Retrospective

Run a retrospective focused on metaproject work — cross-project reviews, research, propagation, and project scaffolding.

Only run this skill when:
- The user explicitly invokes `/retro`
- A major cross-project task is complete

## Steps

1. **Session time analysis**: Read the actual conversation transcript JSONL file to extract real timestamps and produce a time breakdown. Do NOT estimate or guess times from memory.

   **How to read the transcript:**
   - The transcript is at: `~/.claude/projects/<project-path>/<session-id>.jsonl`
   - Find the correct path by globbing `~/.claude/projects/**/*.jsonl` sorted by modification time
   - Use a subagent (Task tool with `general-purpose` type) to read the JSONL file, extract timestamps, and calculate durations

   Present as a phase table:

   | Phase | Duration | User Involvement | Challenges |
   |-------|----------|------------------|------------|

   And a summary:

   | Metric | Duration |
   |--------|----------|
   | Total wall-clock | X min |
   | User hands-on | X min |
   | Automated agent time | X min |

2. **Key observations**: Before asking the user, identify patterns:
   - Which cross-project operations went smoothly?
   - Where did reading from project repos cause issues (stale data, missing files)?
   - Were PRs created correctly? Any friction with GitHub API?
   - Did research produce actionable findings?
   - Was the registry accurate and up to date?

3. **Ask the user**:
   - What worked well?
   - What was frustrating or slower than expected?
   - Anything I should do differently?

4. **Wait for their response** — don't assume answers.

5. **Propose concrete actions** for each issue:

   | Action Type | When to use |
   |-------------|-------------|
   | **Update a skill** | A metaproject skill needs improvement |
   | **Update CLAUDE.md** | A new convention for the metaproject |
   | **Update templates** | The issue affects templates shared with projects |
   | **Update registry** | Project metadata is wrong or incomplete |
   | **Create a ticket** | Needs implementation work |

6. **Get approval and execute** the approved actions.

7. **Log to `docs/process/retrospective.md`**:
   ```markdown
   ## YYYY-MM-DD - [Brief context]

   ### Time Breakdown
   | Phase | Duration | User Involvement | Challenges |
   |-------|----------|------------------|------------|

   **Totals:** X min wall-clock, X min user hands-on, X min automated

   ### Key Observations
   - [Patterns from transcript]

   ### Feedback
   **What worked:** ...
   **What didn't:** ...

   ### Actions Taken
   | Issue | Action Type | Change |
   |-------|-------------|--------|
   ```

8. **Elevate to learnings**: Propose additions to `docs/process/learnings.md`.

9. **Check template impact**: If any learnings should affect templates (and thus all projects), note them and suggest running `/propagate`.

10. **Confirm** what was logged.
