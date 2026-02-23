# Cross-Project Learnings

Aggregated learnings from all registered projects. Each entry is tagged with its source.

Use `/aggregate` to pull new learnings from project repos.

---

## Planning (from health-tool, 2026-02-06)
- Always start with measurable outcomes before any implementation detail — first draft plans often jump to file lists and code changes without stating what "done" looks like
- Propose 2-3 wildly different alternatives per use case with tradeoff tables (effort, risk, usability, impact) — don't default to one approach
- Use mermaid diagrams for reviewability: flowcharts for workflows, component diagrams for architecture, gantt for dependencies
- Plan should produce work packages optimized for parallel subagent execution: clear inputs, outputs, testable acceptance criteria, shared interfaces defined up front
- Include testing & deployment plan with three phases: automated (Claude), handoff (user), manual review (user)

## Planning (from health-tool, 2026-02-09)
- Lead with simplest option, present 2-3 alternatives — over-engineered single-option plans (recurring across multiple sessions) require user redirect before implementation
- When designing data pipelines, ask where data originates in the user's real workflow — don't assume the trigger source
- When the design involves data/workflow separation, ask about the user's mental model of isolation early — "same repo with shared dirs" vs "separate clones" are fundamentally different approaches

## Skills Format (from health-tool, 2026-02-06)
- Skill format: directory with SKILL.md — flat .md files in `.claude/skills/` do NOT appear in the user-invocable skill list
- Frontmatter uses hyphens not underscores: `user-invocable`, `disable-model-invocation`
- The `description` field is what Claude uses to decide when to auto-invoke — make it clear about trigger conditions
- Deploy paths in skills should be relative (not absolute) so they work across worktrees
- Skills should call CLI scripts rather than embedding language one-liners — follows project CLI conventions and is easier to test and maintain

## Skill Auto-Invocation (from health-tool, 2026-02-07)
- Skill auto-invocation is a known Claude Code limitation (~0-20% reliability without hooks) — not Conductor-specific
- Most effective workaround: forced eval hook on UserPromptSubmit that makes Claude explicitly evaluate each skill YES/NO (~84% reliability)
- Plans created via plan mode go to `.claude/plans/` (ephemeral) — use a `/persist-plan` skill or equivalent to save to `docs/product/plans/`

## Code Review (from health-tool, 2026-02-09)
- Code review should be automatic after implementation, not user-requested — added to `/implement` skill as Step 4.5
- Code review consistently catches real bugs: dead code, race conditions, cross-file inconsistencies, date normalization, alignment issues
- Run code review before presenting merge/PR options — not after the user asks

## Testing (from health-tool, 2026-02-06)
- Always run the full pipeline against live data before declaring a feature done — fixture-only testing missed 5+ bugs (timezone issues, field name mismatches, malformed colors, unsorted entries)
- Avoid test duplication across layers — each test should cover something the others don't
- Before adding integration tests, ask "what does this cover that unit tests don't?" — agent built HTTP-level tests duplicating unit coverage

## Process / Safety (from health-tool, 2026-02-07)
- Before running commands with real side effects, verify the scope/filtering matches intent — a flag that controlled downloads didn't control processing, creating unwanted side-effect records
- Record E2E test results in the Linear ticket (definition of done) so future sessions know what was validated
- Clean up dead code created by changes — after an initial fix, unreachable branches may remain

## Conventions Enforcement (from health-tool + booster-backend, 2026-02)
- Agent follows existing anti-patterns instead of project conventions — add explicit "Before Making Changes" checklist to CLAUDE.md with architecture docs and exemplar files to read
- Highest autonomy phases introduce the most convention deviations — the agent needs guidance to cross-reference existing code before writing new code

## Retrospectives (from health-tool, 2026-02-07)
- The `/retro` skill must read the actual JSONL transcript file to calculate time breakdowns — estimating from memory produces fabricated numbers
- Transcript is at `~/.claude/projects/<project-path>/<session-id>.jsonl`
- Retro actions should be classified as: skill change / CLAUDE.md change / doc change / ticket — vague action items don't get executed
- Writing architecture docs during retro reveals real gaps in the skill/rules layer

## Linear Workflow (from health-tool, 2026-02-10)
- Update Linear ticket status at workflow transitions (In Progress, In Review, Done) — automate via a `.claude/rules/linear-workflow.md` rules file

## Third-Party SDK / API Evaluation (from bike-tool, 2026-02-23)
- Always check API constraints (min input length, supported platforms, pricing) BEFORE architecture decisions — Picovoice Porcupine requires wakewords >3 syllables, wasting ~30min of research + architecture discussion
- Research API constraints before implementation — many bugs are discoverable via documentation before coding starts
- Document API constraints in learnings.md at session end, not deferred

## Product Design (from bike-tool, 2026-02-11)
- Consider the user's physical context before proposing UX — toggle vs fire-and-forget matters for hands-busy scenarios (cycling, cooking, driving)
- Ask about context of use early: when/where do they interact, what are their hands doing?

## E2E Testing / Playwright (from booster-frontend, 2026-02-15)
- CSS class sharing can cause false positives in Playwright selectors — use structural selectors (`.prose`, `.animate-bounce`) not shared background classes
- LLM-backed operations need generous timeouts (60-90s) in E2E tests; non-LLM backend endpoints respond in ~1ms
- Use `toPass()` with reload + re-check to poll for async results (e.g. summary generation)
- `gemini-flash` models are dramatically better than Pro for E2E tests: faster, higher quotas

## Backend Model Conventions (from booster-backend, 2026-02-15)
- Before writing a new model/entity, cross-reference existing models for inheritance chain and mixin conventions — convention deviations recur without enforcement
- SQLAlchemy sends Python enum member NAMES (UPPERCASE) to PostgreSQL, not `.value` (lowercase) — be explicit about what the DB stores vs what the API returns

## Notion MCP (from personal-crm, 2026-02-23)
- `notion-update-page` (replace_content_range) and `notion-fetch` by URL frequently fail on the first attempt and succeed immediately on retry — retry once before investigating further
- `notion-fetch` by URL fails with an `invalid_type` error; always use the page ID directly instead of the full Notion URL

## Research Sessions (from personal-crm, 2026-02-23)
- Flag uncertainty explicitly on legal, procedural, or factual claims — don't assert with confidence without a citation
- Research sessions have no workflow scaffolding — Implementation/Test/Commit conventions don't apply; use a lighter retro trigger
