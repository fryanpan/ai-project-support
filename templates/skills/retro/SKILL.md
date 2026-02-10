---
name: retro
user-invocable: true
description: Run a retrospective with transcript analysis and log feedback. Only use when the user explicitly invokes /retro, or when a full plan implementation is complete (all work packages done and verified). Do NOT auto-invoke mid-session for long discussions.
---
# Retrospective

Only run this skill when:
- The user explicitly invokes `/retro`
- A full plan implementation is complete (all work packages done and verified)

## Steps

1. **Session time analysis**: Read the actual conversation transcript JSONL file to extract real timestamps and produce a time breakdown. Do NOT estimate or guess times from memory.

   **How to read the transcript:**
   - The transcript is at: `~/.claude/projects/<project-path>/<session-id>.jsonl`
   - Find the correct path by checking the context compaction summary (which includes the file path) or by globbing `~/.claude/projects/**/*.jsonl` sorted by modification time
   - Use a subagent (Task tool with `general-purpose` type) to read the JSONL file, extract timestamps, and calculate durations

   Present as a detailed phase table:

   | Phase | Duration | User Involvement | Challenges |
   |-------|----------|------------------|------------|
   | Design & planning | 42 min | Heavy — user drove decisions | Agent jumped ahead |
   | Implementation | 15 min | None — fully automated | Context overflow |

   And a summary:

   | Metric | Duration |
   |--------|----------|
   | Total wall-clock | X min |
   | User hands-on | X min |
   | Automated agent time | X min |
   | User idle/away | X min |

2. **Key observations from transcript**: Before asking the user for feedback, identify patterns yourself:
   - Where did Claude work most independently? Why?
   - Where were the most user interactions needed? What caused them?
   - Were there avoidable back-and-forth cycles?
   - What was the ratio of productive work to debugging/rework?

3. **Ask the user**:
  - What worked well in how we approached this?
  - What was frustrating or slower than expected?
  - Anything I should do differently?

4. **Wait for their response** - don't assume or fill in answers.

5. **Propose concrete actions**: For each issue identified, propose a specific deliverable:

   | Action Type | When to use | What to do |
   |-------------|-------------|------------|
   | **Update a skill** | A skill's behavior caused the issue | Read the SKILL.md, propose the specific edit |
   | **Update CLAUDE.md** | A new rule or convention should be followed | Propose the specific addition |
   | **Update docs** | Architecture, decisions, or learnings are wrong/missing | Propose the specific edit |
   | **Create a ticket** | The fix requires implementation work | Draft the ticket title + description |
   | **No action needed** | One-off or already resolved | Explain why |

6. **Get approval and execute actions**: Present all proposed actions, ask which to take, then execute.

7. **Log to `docs/process/retrospective.md`** using this format:
   ```markdown
   ## YYYY-MM-DD - [Brief context]

   ### Time Breakdown
   | Phase | Duration | User Involvement | Challenges |
   |-------|----------|------------------|------------|

   **Totals:** X min wall-clock, X min user hands-on, X min automated, X min idle

   ### Key Observations
   - [Patterns identified from transcript]

   ### Feedback
   **What worked:** [User's feedback]
   **What didn't:** [User's feedback]

   ### Actions Taken
   | Issue | Action Type | Change |
   |-------|-------------|--------|
   ```

8. **Elevate to learnings**: Propose specific additions to `docs/process/learnings.md`.

9. **Confirm** what was logged and what actions were taken.
