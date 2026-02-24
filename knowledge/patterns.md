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

**Note on timing:** Most of the evidence here is from before superpowers was adopted. superpowers:brainstorming + superpowers:writing-plans already enforce outcomes-first planning and outcomes-before-files structure.

**Propagation:** The fix is superpowers adoption + an active UserPromptSubmit hook so brainstorming triggers reliably. Project-level `/plan` or `/implement` skills that duplicate this are now redundant — don't add them. Focus instead on ensuring the hook is installed and working.

---

## Pattern: Over-Engineered Initial Plans (Recurring)

**Observed in:** health-tool (Sprint 3, HEA-27, HEA-24), bike-tool (BC-34), booster-backend (M2M vs FK)

**Description:** The agent's first plan proposal is often too complex — involving multiple new directories, abstractions, or data structures when a simpler approach exists. User redirect is required to find the simpler path.

**Root cause:** Agent defaults to exploring one detailed solution rather than presenting trade-offs. Without being prompted to consider alternatives, it dives deep on whatever approach feels natural.

**Root cause (updated):** superpowers:brainstorming step 3 already requires "Propose 2-3 approaches with trade-offs." The real problem was that using Claude's built-in **Plan mode** bypasses superpowers and triggers Claude's native planning logic instead — which has no such requirement.

**Fix pattern:** Don't use Plan mode. Let superpowers:brainstorming handle design exploration. No CLAUDE.md changes or parallel skills needed.

**Propagation:** Communicate to all projects: avoid Plan mode, use `/brainstorm` instead. This is a workflow habit change, not a template change.

---

## Pattern: Automatic Code Review After Implementation

**Observed in:** health-tool (added to /implement Step 4.5), bike-tool (multiple sessions), booster-frontend, booster-backend

**Description:** Code review consistently catches real bugs — dead code, race conditions, cross-file inconsistencies, missing validation, alignment issues. But in most projects it was manually requested, not automatic.

**Note:** superpowers:subagent-driven-development already includes two-stage code review (spec compliance + code quality) after every task, plus a final review before finishing. superpowers:finishing-a-development-branch also includes review before merge.

**Fix pattern:** Ensure projects use superpowers:subagent-driven-development for implementation. Project-level `/implement` skills that add a manual code review step are now redundant.

**Propagation:** No template change needed. Retire project-level `/implement` skills that duplicate superpowers workflows.

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

**Fix pattern:** This requirement is project-specific — only projects with external data sources (APIs, cloud DBs, third-party services) need a live-data smoke test. Rather than embedding it in a project-level `/implement` skill that duplicates superpowers, it belongs in a project-specific rules file (e.g. `.claude/rules/integration-testing.md`) that supplements superpowers:subagent-driven-development.

**Open question:** Health-tool has a full `/implement` skill predating superpowers. Consider: (1) slimming it to just the project-specific live-data step and referencing superpowers for the rest, or (2) replacing it entirely with a `.claude/rules/integration-testing.md` rule that Claude reads before finalizing any feature.

**Propagation:** For projects with external API dependencies, create `templates/rules/integration-testing.md` with a "run one smoke test against live data before handoff" requirement. Push via `/propagate`. Don't duplicate superpowers workflows.

---

## Pattern: Notion MCP Retry Behavior

**Observed in:** personal-crm (2026-02-23), metaproject (project-support)

**Description:** `notion-update-page` (replace_content_range) and `notion-fetch` by URL fail on first attempt ~30-50% of the time but succeed immediately on retry. Also: `notion-fetch` by URL fails with `invalid_type` — use page ID directly.

**Fix pattern:** Create a shared rules file `templates/rules/notion-mcp.md` with the retry and page ID guidance. Propagate to all projects.

**Propagation:** Since all active projects use Notion, this should go everywhere via `/propagate`. Create the template rule file, then push to: personal-crm, blog-assistant, booster-frontend, booster-backend, health-tool, bike-tool, tasks. **Action: create `templates/rules/notion-mcp.md` now.**

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

**Propagation:** Each project should add a "Third-Party SDK Evaluation" section to `docs/process/learnings.md` with their specific API gotchas (already done in health-tool and bike-tool). For the general principle ("check constraints before committing"), consider adding a step to superpowers:brainstorming or superpowers:writing-plans — not a project-level skill.
