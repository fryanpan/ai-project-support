# Cross-Cutting Patterns

Patterns identified across multiple projects. These inform template updates and propagation decisions.

---

## Pattern: Plan-First → Fast Implementation

**Observed in:** health-tool (every sprint), bike-tool (BC-34, BC-46, BC-55, BC-61), booster-frontend (summary revision), booster-backend (summary history)

**Description:** When a solid plan is written and approved before coding starts, implementation runs fast (~3-19 min for multi-file features) with zero rework. When implementation starts without a plan, it leads to over-engineering, wrong assumptions, and user redirect mid-session.

**Evidence:**
- health-tool HEA-9: "Implementation completed all 6 tasks in 3 minutes with zero rework — plan was clear enough for clean execution"
- bike-tool BC-61: "17 min for full initial feature (9 files, model + synthesizer + engine + UI + tests)"
- booster-backend PR #161: Phase 1 with ~101m agent time introduced all convention deviations; better planning prevented rework in later phases

**Propagation:** Ensure all projects have a `/plan` or `/implement` skill that enforces outcomes-first planning. Already in health-tool and bike-tool templates.

---

## Pattern: Over-Engineered Initial Plans (Recurring)

**Observed in:** health-tool (Sprint 3, HEA-27, HEA-24), bike-tool (BC-34), booster-backend (M2M vs FK)

**Description:** The agent's first plan proposal is often too complex — involving multiple new directories, abstractions, or data structures when a simpler approach exists. User redirect is required to find the simpler path.

**Root cause:** Agent defaults to exploring one detailed solution rather than presenting trade-offs. Without being prompted to consider alternatives, it dives deep on whatever approach feels natural.

**Fix pattern:** Add "lead with simplest option, present 2-3 alternatives" to CLAUDE.md Before Making Changes, and enforce multi-option proposals in the `/plan` skill.

**Propagation:** This CLAUDE.md addition should be propagated to all projects. Worth adding to the templates.

---

## Pattern: Automatic Code Review After Implementation

**Observed in:** health-tool (added to /implement Step 4.5), bike-tool (multiple sessions), booster-frontend, booster-backend

**Description:** Code review consistently catches real bugs — dead code, race conditions, cross-file inconsistencies, missing validation, alignment issues. But in most projects it was manually requested, not automatic.

**Fix pattern:** Add automatic code review as the final step in any `/implement` skill, triggered before presenting merge/PR options.

**Propagation:** Templates should include an `/implement` skill that has code review as a built-in step. Already fixed in health-tool. Should be propagated to bike-tool, booster-frontend, booster-backend.

---

## Pattern: Agent Ignores Existing Conventions Without Explicit Guidance

**Observed in:** health-tool (HEA-7: skipped learnings.md; HEA-16: followed anti-pattern in skill), booster-backend (PR #161: didn't check existing model patterns)

**Description:** When writing new code, the agent defaults to patterns it "knows" rather than checking existing project code for conventions. This leads to convention deviations that require rework.

**Fix pattern:** Add a "Before Making Changes" checklist to CLAUDE.md that mandates reading:
1. Architecture/design docs
2. Exemplar files (e.g., one existing model, one existing route)
3. `docs/process/learnings.md` for known gotchas

**Propagation:** All projects should have this checklist in CLAUDE.md. Already in health-tool and booster-backend.

---

## Pattern: Live Integration Tests Reveal Bugs Fixture-Only Tests Miss

**Observed in:** health-tool (Sprint 3: 5+ bugs; HEA-9: unwanted Asana tasks)

**Description:** Tests against fixtures or mocks pass while the same code fails against live data — timezone issues, field name mismatches, API behavior differences, filtering bugs. The final validation step must include a live/integration run.

**Fix pattern:** Add a mandatory "run against live data" step to the `/implement` skill before handoff, even if just a dry run against real API data.

**Propagation:** Add to health-tool's `/implement` skill (partially done). Worth adding to all projects with external data sources.

---

## Pattern: Notion MCP Retry Behavior

**Observed in:** personal-crm (2026-02-23), metaproject (project-support)

**Description:** `notion-update-page` (replace_content_range) and `notion-fetch` by URL fail on first attempt ~30-50% of the time but succeed immediately on retry. Also: `notion-fetch` by URL fails with `invalid_type` — use page ID directly.

**Fix pattern:** Add to CLAUDE.md: retry Notion MCP calls once before investigating. Use page ID for `notion-fetch`, not URL.

**Propagation:** Already in personal-crm learnings. Should be propagated to any project using Notion MCP tools (personal-crm, blog-assistant, booster-frontend, booster-backend).

---

## Pattern: Retro Requires Reading JSONL Transcript

**Observed in:** health-tool (HEA-5), bike-tool (BC-61)

**Description:** Retro time breakdowns estimated from memory are fabricated. The `/retro` skill must be updated to mandate reading the actual JSONL transcript file at `~/.claude/projects/<path>/<session-id>.jsonl`.

**Fix pattern:** Update `/retro` SKILL.md to explicitly require a subagent to read and parse the JSONL transcript for timestamps.

**Propagation:** Already fixed in health-tool's `/retro` skill. Templates should include this fix. Run `/propagate` to push to other projects.

---

## Pattern: Third-Party SDK Constraint Check Before Architecture

**Observed in:** bike-tool (Picovoice Porcupine: wakeword syllable requirement), health-tool (Cloudflare User-Agent block)

**Description:** Committing to an SDK or API before checking its constraints leads to expensive dead ends. In bike-tool, ~30min of research + architecture was wasted because Picovoice requires >3 syllable wakewords. In health-tool, the Cloudflare User-Agent block was already documented but ignored.

**Fix pattern:** Add to planning workflow: "For each third-party dependency, verify it supports the exact use case before designing around it."

**Propagation:** bike-tool already added a "Third-Party SDK Evaluation" section to learnings.md. Health-tool added a similar rule. Should be in the `/plan` skill template.
