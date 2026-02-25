# Aggregation Log

History of `/aggregate` passes. Each section records what was found and synthesized in that run.

---

## 2026-02-24

### Cross-Cutting Patterns

Patterns observed across multiple projects with propagation recommendations.

#### Plan-First → Fast Implementation

**Observed in:** health-tool (every sprint), bike-tool (BC-34, BC-46, BC-55, BC-61), booster-frontend (summary revision), booster-backend (summary history)

**Description:** When a solid plan is written and approved before coding starts, implementation runs fast (~3-19 min for multi-file features) with zero rework. When implementation starts without a plan, it leads to over-engineering, wrong assumptions, and user redirect mid-session.

**Note:** Most evidence is pre-superpowers. superpowers:brainstorming + superpowers:writing-plans already enforce outcomes-first planning. Project-level `/plan` skills that duplicate this are redundant.

**Propagation:** Ensure superpowers is adopted and the UserPromptSubmit hook is active so brainstorming triggers reliably.

---

#### Over-Engineered Initial Plans (Recurring)

**Observed in:** health-tool (Sprint 3, HEA-27, HEA-24), bike-tool (BC-34), booster-backend (M2M vs FK)

**Description:** The agent's first proposal is often too complex. User redirect is required to find the simpler path.

**Root cause:** Using Claude's built-in **Plan mode** bypasses superpowers and triggers Claude's native planning logic, which has no "propose 2-3 alternatives" requirement. superpowers:brainstorming step 3 already requires this.

**Fix:** Don't use Plan mode. Use `/brainstorm` instead. This is a workflow habit change, not a template change.

---

#### Automatic Code Review After Implementation

**Observed in:** health-tool (added to /implement Step 4.5), bike-tool (multiple sessions), booster-frontend, booster-backend

**Description:** Code review consistently catches real bugs — dead code, race conditions, cross-file inconsistencies, missing validation, alignment issues.

**Note:** superpowers:subagent-driven-development already includes two-stage review (spec compliance + code quality) after every task. Project-level `/implement` skills that add a manual review step are redundant.

**Propagation:** Use superpowers:subagent-driven-development. Retire project-level `/implement` skills.

---

#### Agent Ignores Existing Conventions Without Explicit Guidance

**Observed in:** health-tool (HEA-7, HEA-16), booster-backend (PR #161)

**Description:** When writing new code, the agent defaults to patterns it "knows" rather than checking existing project code. Highest-autonomy phases introduce the most convention deviations.

**Fix pattern:** Add a "Before Making Changes" checklist to CLAUDE.md:
1. Read architecture/design docs
2. Read exemplar files (one existing model, one existing route)
3. Read `docs/process/learnings.md` for known gotchas

**Propagation:** Already in health-tool and booster-backend. Propagate to others.

---

#### Live Integration Tests Reveal Bugs Fixture-Only Tests Miss

**Observed in:** health-tool (Sprint 3: 5+ bugs; HEA-9: unwanted Asana tasks)

**Description:** Tests against fixtures pass while the same code fails against live data — timezone issues, field name mismatches, API behavior differences, filtering bugs.

**Fix pattern:** Project-specific rules file (`.claude/rules/integration-testing.md`) requiring a live-data smoke test before handoff — supplements superpowers rather than replacing it.

**Propagation:** For projects with external API dependencies only. Don't duplicate superpowers workflows.

---

#### Notion MCP Retry Behavior

**Observed in:** personal-crm (2026-02-23), metaproject (project-support)

**Description:** `notion-update-page` and `notion-fetch` by URL fail on first attempt ~30-50% of the time and succeed immediately on retry. `notion-fetch` by URL fails with `invalid_type` — use page ID directly.

**Propagation:** `templates/rules/notion-mcp.md` created. Propagate to all projects (all use Notion).

---

#### Retro Requires Reading JSONL Transcript

**Observed in:** health-tool (HEA-5), bike-tool (BC-61)

**Description:** Time breakdowns estimated from memory are fabricated. Must read the actual JSONL at `~/.claude/projects/<path>/<session-id>.jsonl`.

**Propagation:** Already fixed in templates/skills/retro. Propagate to projects with older retro skills.

---

#### Third-Party SDK Constraint Check Before Architecture

**Observed in:** bike-tool (Picovoice: wakeword syllable requirement), health-tool (Cloudflare User-Agent block)

**Description:** Committing to an SDK before checking its constraints leads to expensive dead ends. ~30min wasted on Picovoice because it requires >3 syllable wakewords.

**Propagation:** Each project should log API gotchas in `docs/process/learnings.md`. For the general principle, consider adding a step to superpowers:brainstorming — not a project-level skill.

---

### Additional Project Observations

Learnings from individual projects that don't yet rise to a cross-cutting pattern.

#### Skills Format (from health-tool, 2026-02-06)
- Skill format: directory with SKILL.md — flat .md files in `.claude/skills/` do NOT appear in the user-invocable skill list
- Frontmatter uses hyphens not underscores: `user-invocable`, `disable-model-invocation`
- The `description` field drives auto-invocation — make trigger conditions explicit
- Deploy paths in skills should be relative (not absolute) so they work across worktrees
- Skills should call CLI scripts rather than embedding language one-liners

#### Skill Auto-Invocation (from health-tool, 2026-02-07)
- Auto-invocation is a known Claude Code limitation (~0-20% reliability without hooks)
- Most effective workaround: forced eval hook on UserPromptSubmit (~84% reliability)
- Plans created via plan mode go to `.claude/plans/` (ephemeral) — use a persist-plan skill to save to `docs/product/plans/`

#### Linear Workflow (from health-tool, 2026-02-10)
- Update ticket status at transitions (In Progress, In Review, Done) — automate via `.claude/rules/linear-workflow.md`

#### Product Design (from bike-tool, 2026-02-11)
- Consider the user's physical context before proposing UX — toggle vs fire-and-forget matters for hands-busy scenarios
- Ask about context of use early: when/where do they interact, what are their hands doing?

#### E2E Testing / Playwright (from booster-frontend, 2026-02-15)
- CSS class sharing causes false positives — use structural selectors (`.prose`, `.animate-bounce`) not shared background classes
- LLM-backed operations need generous timeouts (60-90s); non-LLM endpoints respond in ~1ms
- Use `toPass()` with reload + re-check to poll for async results
- `gemini-flash` models are dramatically better than Pro for E2E tests: faster, higher quotas

#### Backend Model Conventions (from booster-backend, 2026-02-15)
- Before writing a new model, cross-reference existing models for inheritance chain and mixin conventions
- SQLAlchemy sends Python enum member NAMES (UPPERCASE) to PostgreSQL, not `.value` (lowercase)

#### Research Sessions (from personal-crm, 2026-02-23)
- Flag uncertainty explicitly on legal, procedural, or factual claims — don't assert with confidence without a citation
- Research sessions have no workflow scaffolding — use a lighter retro trigger
