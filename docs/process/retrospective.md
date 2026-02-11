# Retrospectives

Session retrospectives and process improvements.

## 2026-02-11 - Propagate commit discipline conventions

### Time Breakdown
| Phase | Duration | User Involvement | Challenges |
|-------|----------|------------------|------------|
| Initial exploration | 3 min | None — automated | Read stale project repos |
| User interrupt + redirect | 0.6 min | High — user caught staleness bug | — |
| Planning freshness fix | 1.5 min | User-directed | — |
| Implementing freshness fix | 1.3 min | None — automated | Edit tool required re-reads; step renumbering tedious |
| Computing propagation diffs | 1.2 min | None — automated | — |
| User reviews diff + decides strategy | 5.3 min | High — chose worktree approach | — |
| Creating worktrees, changes, PRs | 15 min | None — automated | Health-tool customizations nearly clobbered |
| User review + /retro | 9.4 min | Idle/review | — |

**Totals:** 38 min wall-clock, 6 min user hands-on, 22 min automated, 10 min idle

### Key Observations
- Agent read from stale project repos despite CLAUDE.md freshness guidance — user had to interrupt and redirect
- Propagation subagent replaced health-tool's workflow-conventions wholesale, nearly clobbering 3 project-specific lines — caught during diff review
- Worktree workflow (create, edit, commit, push, PR, cleanup) was clean once established
- Step renumbering when inserting into numbered lists required 3-4 cascading edits

### Feedback
**What worked:** Worktree-based propagation, bundling changes per project, catching customization clobbering during review
**What didn't:** Agent didn't self-enforce freshness; propagation nearly lost project-specific lines

### Actions Taken
| Issue | Action Type | Change |
|-------|-------------|--------|
| Stale repo reads | Update skills | Added `git pull --ff-only` step to propagate, aggregate, update-project skills + CLAUDE.md |
| Customization clobbering | Update propagate skill | Added guidance to diff existing files and apply only additions |
| Worktree + bundling convention | Update propagate skill | Changed from one-PR-per-artifact to one-PR-per-project with worktrees |
| Step renumbering friction | Update learnings | Added note about renumbering in a single edit |
| Propagation conventions | Update learnings | Added notes about worktrees, bundling, and diffing before writing |

## 2026-02-10 - PRJ-2: Streamline and document workflow

### Time Breakdown
| Phase | Duration | User Involvement | Challenges |
|-------|----------|------------------|------------|
| Exploration | 9.4 min | None — automated | 2 parallel subagents explored metaproject + managed projects |
| Planning | 8.7 min | Heavy — 2 rounds of feedback | User refined retro triggers and requested workflow diagram |
| Implementation | 3.2 min | None — automated | 9 files across 8 tasks |
| Propagation | 5.2 min | None — automated | 2 parallel subagents created PRs on bike-tool + health-tool |
| Commit & PR | 0.7 min | Light | Straightforward |
| Code Review | 3.5 min | None — automated | 12 subagents, caught stale refs outside changeset |
| Fix review issues | 0.9 min | Light | Fixed 3 files with stale references |
| Check subproject PRs | 0.8 min | None — automated | Both clean |

**Totals:** 43 min wall-clock, 10 min user hands-on, 22 min automated, 18 min user idle/review

### Key Observations
- Code review caught stale references to deleted `/plan` and `/implement` in files outside the changeset (new-project, update-project, use-cases)
- Subagent parallelism compressed wall-clock time significantly (exploration, propagation, code review)
- Implementation was fast (3.2 min for 9 files) — task list kept things organized
- Planning phase had good user interaction — 2 rounds of targeted feedback refined the plan

### Feedback
**What worked:** Plan mode, parallel subagents for propagation and code review, structured code review catching ripple effects
**What didn't:** Template consistency — deleting artifacts left stale references in files outside the direct changeset. Concern about scaling as templates and project count grow.

### Actions Taken
| Issue | Action Type | Change |
|-------|-------------|--------|
| Stale refs when deleting templates | Learnings | Added to `docs/process/learnings.md`: grep entire repo for references before committing template deletions |
| Template consistency at scale | Ticket | PRJ-4: Investigate consistency checks for template changes |
| Propagation scalability | Ticket | PRJ-5: Evaluate propagation scalability as project count grows |

## 2026-02-10/11 - Booster initial project review

### Time Breakdown
| Phase | Duration | User Involvement | Challenges |
|-------|----------|------------------|------------|
| Setup & access verification | 14m | Light — 3 msgs | Token troubleshooting for Notion MCP |
| Repo review & team analysis | 22m | Medium — 4 msgs | Reading 3 repos + GitHub PRs + Notion board |
| PR duration & developer deep dive | 28m | Medium — 4 msgs | Commit span analysis across 142 PRs |
| Team workflow & layering analysis | 44m | Light — 3 msgs | 20 tool calls, heavy GitHub API + Notion fetches |
| Notion notes & parallel work | 47m | Medium — 4 msgs | Writing findings to multi-page Notion structure |
| Feature grouping & subpages | 53m | Medium — 4 msgs | Grouping 142 PRs into 13 features with FTE breakdowns |
| Recommendations & template review | 35m | Light — 3 msgs | Reviewing all metaproject templates for patterns |
| Implementation plan & research | 28m | Heavy — 5 msgs | Antigravity + Conductor research, user corrections on intent |
| Recommendations rewrite (4 rounds) | 43m | Heavy — 4 msgs | Iterative refinement based on user feedback |

**Totals:** ~5h 17m active (25h wall-clock with overnight), ~1.5-2h user hands-on, ~3-3.5h automated, 36 user messages, 123 tool calls

### Key Observations
- Research agents (Antigravity, Conductor, backend tests) each returned comprehensive findings in ~3 min — high leverage
- Feature grouping analysis (142 PRs → 13 features) produced the most compelling insight
- Recommendations page needed 4 rewrites to get right — initial versions buried the lede, used jargon, were too certain in tone
- Notion `allow_deleting_content: true` archived child pages unexpectedly — user had to restore from trash
- Assumed backend needed new fast tests; team already had `make test-base` with ~150-200 non-DB tests
- Wrote Conductor WP as "config files to create" when user meant "teach the team to install and use it"
- Two context continuations hit during the session — summary was good enough to resume but some early detail was lost

### Feedback
**What worked:** Multi-page Notion structure, research agents for external tools, feature grouping analysis, user's reorganized review page structure
**What didn't:** Over-building before checking existing state (backend tests, Conductor), recommendations needed multiple rewrites to match user's communication style, Notion archiving gotcha

### Actions Taken
| Issue | Action Type | Change |
|-------|-------------|--------|
| Recommendations went through 4 rewrites | Update learnings | Lead with findings, be brief, don't invent jargon |
| Notion archiving gotcha | Update learnings | Document `allow_deleting_content` risk |
| Assumed new tests needed vs checking existing | Update learnings | Check existing infra before proposing new |
| Booster review page structure is reusable | Create template | Save review page structure as a skill/template |
| No `/review` skill exists | Create skill | Build a project review skill based on this session |
| Booster implementation work | Create ticket | PRJ-6: Implement Booster project setup + test workflow |

## 2026-02-10 - Multi-ticketing design doc + ticket

### Time Breakdown
| Phase | Duration | User Involvement | Challenges |
|-------|----------|-----------------|------------|
| Codebase exploration | 2m 07s | Passive (asked question) | Subagent explored ~30+ files |
| User decision-making | 3m 15s | Active (reading findings, deciding next step) | None |
| Agent planning | 45s | Passive (agent drafting plan) | None |
| Plan approval wait | 5m 45s | Active (reviewing plan) | None |
| Execution (doc + ticket) | 1m 00s | Passive (fully automated) | Needed ToolSearch for Linear MCP tool |
| Follow-up (tag with ticket #) | 11s | Active (small request) | None |

**Totals:** ~13 min wall-clock, ~9 min user hands-on, ~4 min automated

### Key Observations
- Exploration was thorough and appropriate for the initial "how does this work?" question
- Plan mode added ~6.5 min overhead for a 2-deliverable task (one doc, one ticket)
- Execution was fast once approved — doc + ticket in ~1 min
- No friction with cross-project reads; registry and docs were clean

### Feedback
**What worked:** Overall approach was good, design doc captured the right level of detail
**What didn't:** Plan mode felt like overkill for a small task

### Actions Taken
| Issue | Action Type | Change |
|-------|-------------|--------|
| Plan mode overkill for small tasks | Update learnings | Added note about skipping plan mode for lightweight deliverables |
| Retro questions should be open-ended | Update learnings | Added note about using open-ended AskUserQuestion in retros |
