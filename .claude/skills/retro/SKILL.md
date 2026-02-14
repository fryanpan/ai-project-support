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

1. **Session time analysis**: Read the actual conversation transcript JSONL file to extract real timestamps and produce a time breakdown. Do NOT estimate or guess times from memory. Note the current time before starting — you'll record how long this analysis took in the retro log.

   **How to read the transcript:**
   - The transcript is at: `~/.claude/projects/<project-path>/<session-id>.jsonl`
   - Find the correct path: the project directory path determines the subfolder under `~/.claude/projects/`. Convert the current working directory to the Claude projects path format (slashes become dashes, e.g., `/Users/me/myproject` → `-Users-me-myproject`), then glob for `~/.claude/projects/<converted-path>/*.jsonl` sorted by modification time. Only fall back to globbing all `~/.claude/projects/**/*.jsonl` if no match is found.
   - **Verify before proceeding**: Read the first few lines of the JSONL file and confirm it contains messages about work done in this project. If the transcript doesn't match (e.g., it's from a different worktree), try the next most recent file or report that the transcript couldn't be found.
   - Use a subagent (Task tool with `general-purpose` type) to read the JSONL file, extract timestamps, and calculate durations

   Present as a time breakdown table with proportional bars and a metrics summary:

   | Started | Phase | 👤 Hands-On Time | 🤖 Agent Time | Problems |
   |---------|-------|-----------------|---------------|----------|
   | Feb 10 10:00am | Build (engine restart, voice recog, UI tweaks) | ██████ 60m | ███ 30m | ⚠ 5 fix cycles |
   | Feb 10 11:30am | Research (BT routing for AirPods + external mics) | | █████ 45m | |
   | Feb 10 1:00pm | Review (code review, docs, feedback log) | | ██ 15m | |

   **Format rules:**
   - **Started**: Date and wall-clock time when the phase began (from transcript timestamps)
   - **Bars**: Use █ blocks proportional to time (each █ ≈ 10min), followed by the minute label (e.g., `███ 30m`)
   - **Empty cells**: Leave the column blank if that role wasn't involved in the phase
   - **Problems**: Inline with ⚠ marker — only for phases that had real friction or rework
   - **Sort**: Chronological (by start time)
   - **Brevity**: Keep the table to 10 rows max. Start with high-level phases (plan, build, test, review) and only split a phase into sub-rows if it was long and had distinct chunky subparts. A 4-row table is better than a 12-row table. Include a brief parenthetical after the label explaining what was in the phase, e.g., "Build (edited 2 retro skills, tested format)" not just "Build".

   | Metric | Duration |
   |--------|----------|
   | Total wall-clock | X hours |
   | Hands-on | X hours (Y%) |
   | Automated agent time | X hours (Y%) |
   | Idle/testing/away | X hours (Y%) |

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
   | Started | Phase | 👤 Hands-On Time | 🤖 Agent Time | Problems |
   |---------|-------|-----------------|---------------|----------|
   | ... | ... | ... | ... | ... |

   ### Metrics
   | Metric | Duration |
   |--------|----------|
   | Total wall-clock | X hours |
   | Hands-on | X hours (Y%) |
   | Automated agent time | X hours (Y%) |
   | Idle/testing/away | X hours (Y%) |
   | Retro analysis time | X min |

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

9. **Commit** all retro changes (actions, retrospective log, learnings) with message: `docs: retro for [context]`

10. **Check template impact**: If any learnings should affect templates (and thus all projects), note them and suggest running `/propagate`.

11. **Confirm** what was logged.
