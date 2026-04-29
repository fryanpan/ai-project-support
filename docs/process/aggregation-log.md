# Aggregation Log

History of `/aggregate` passes. Each section records what was found and synthesized in that run.

Project names are abstracted (this log is in a public repo). Use category labels: "personal-CRM-style project", "family-bike-routing project", "personal-finance project", etc.

---

## 2026-04-29 — W1+W2 aggregation

Covers 2026-04-13 → 2026-04-29 across all registered projects. Six projects contributed material learnings or retros in this window. The remaining ~12 projects had no new entries (most older personal projects haven't been actively touched; three brand-new scaffolds — live-feedback-plugin, weekly-review, ux-review-plugin — only have placeholder learnings/retro files).

The two booster (advisory) project worktrees (~/dev/crabgrass-frontend, ~/dev/crabgrass-backend) and the bike-tool worktree (~/dev/bike-tool) were not present locally — couldn't pull or read. Bike-tool is now superseded by the family-bike-routing project anyway (per 2026-04-13 aggregation note about duplication); the booster engagement is paused.

### personal-CRM-style project
- 2026-04-17 [Silent data corruption] — When navigation silently fails (returns False, or `page.goto("")` no-ops), Playwright `page.evaluate` happily captures whatever page is currently loaded — typically the operator's own profile/feed left over from a warmup browse. Combined with a correct downstream key (`linkedin_url` index), the wrong-person data was PATCHed onto the right Notion entries — five entries silently corrupted in production before manual restore. Root cause: `_get_url` accepted both `"url"` and `"linkedin_url"`, but `navigation.py` only read `"url"`. Always verify `page.url` matches expected slug before extraction; treat boolean returns as load-bearing; share helpers for input-key normalization across modules.

### family-bike-routing project
- W1 [Routing graph correctness] — `findNearestNode` on a directed graph must be role-aware AND reachability-aware. Snapping to the geometrically nearest node fails ~23% of route pairs (41% in SF) because (a) end-snap can land on the upstream terminus of a one-way (zero incoming) and (b) some nodes sit on tiny directed islands not reachable from start. Fix: pass `role: 'start' | 'end'`, require outgoing-for-start / incoming-for-end, AND pre-compute directed-reachable BFS set from start to restrict end-snap. Cap snap distance at 1km to preserve disconnected-graph contract.
- W1 [Mode rule design] — Stamina is orthogonal to safety; don't conflate `maxContinuousKm` with infrastructure quality. Bike-priority infra (Fahrradstraße, SF Slow Streets, living streets) must be excluded from the "shared-surface" caution slowdown, otherwise the router detours onto cycleways at full speed to escape Fahrradstraßen at 5 km/h. Hard-rejected edges should become bridge-walks (added back at walking speed with `isWalking: true`), not drops — A* needs graph connectivity even through stressful infrastructure.
- W1 [Spec invariants] — Kid-confident must be a strict surface superset of kid-starting-out. When the display classifier flagged `paving_stones` as rough for confident but fine for starting-out, users perceived it as "confident sees less preferred infra than starting-out" — opposite of intended hierarchy. Monotonicity invariants ("as skill increases, accepted set grows") should be tested explicitly.
- W1 [OSM data sparsity] — `width` / `est_width` / `lanes` on cycleways are too sparsely tagged to act on. Single-digit % of Berlin cycleways have a `width=*` tag. A width filter would only catch the minority that ARE tagged narrow, creating visible inconsistency. Decision: don't read width in router; revisit only if OSM coverage materially improves.
- W1 [Display vs routing classifier] — Two parallel classifiers drift silently; one source of truth (`classifyEdge` for routing, `classifyOsmTagsToItem` for display) is required. Speed-based costs (`distance / speed`) beat arbitrary penalty multipliers — they naturally make walking bridges expensive without special-case logic, and compose cleanly with multimodal routing.
- W1 [Stacked PRs] — Squash-merging the base of a stacked PR makes the stacked PR DIRTY. GitHub sees the squash commit on main as a new SHA, doesn't match the original commits in the stacked branch, reports conflicts. Fix: merge `origin/main` into the stacked branch, `git checkout --ours` to resolve (stacked branch supersedes the squashed base by definition), commit the merge, push.
- W2 [Frozen artifacts] — When public content (launch blog post) pins to versioned screenshot URLs, document the frozen-folder rule in learnings so future cleanup passes don't thin them out. Future runs naturally write to fresh dated folders, so the policy is "leave alone" not "rebuild."

### personal-finance project
- W2 [Tax — IRA aggregation rule] — Form 8606 pro-rata aggregates ALL Traditional + Rollover + SEP + SIMPLE IRAs across ALL institutions on Dec 31, not just one account. Always confirm year-end balance is $0 across every IRA before declaring a "clean" backdoor.
- W2 [Tax — donation lot reconciliation] — 1099-B doesn't capture cost basis for charitable stock donations (gifts aren't sold). Etrade's donation confirmation only shows position-wide AVERAGE price. Always download portfolio lot CSVs BOTH before and immediately after each donation; reconciling the two snapshots reveals exactly which lots were donated even when "specific tax lot selected" was used.
- W2 [Tax — kiddie tax + trust TIN] — A "FBO" (for benefit of) account can use beneficiary's SSN (income → kiddie tax) OR a trust EIN (trust files 1041; only K-1 distributions hit beneficiary). Always check recipient TIN on the 1099 before deciding. Irrevocable non-grantor trusts file their own 1041 — kiddie tax only applies to amounts distributed via K-1.

### research-notes project
- W1 [Scheduling] — `/schedule` skill and `RemoteTrigger` tool both require claude.ai account auth (not API key auth) — run `/login` first. `CronCreate` is session-local only (dies when session ends) — not suitable for daily tasks. For persistent daily automation: GitHub Actions cron or `/schedule` after login.

### conductor / metaproject
- W1 [Peer session administration] — The conductor can kill and respawn peer sessions without user intervention. Recipe: `lsof -a -d cwd -Fpn` to find processes by cwd, confirm which is `claude` via `ps`, kill, then `respawn.py --execute` (detects gap, spawns missing). Useful for picking up new env vars via direnv or after settings/discord config changes.
- W1 [Orphaned MCP servers] — Bun processes running claude-hive-mcp/server.ts can accumulate when subagents exit without reaping children (reparented to PID 1). Periodic sweep: `ps aux | grep 'claude-hive-mcp/server.ts' | grep -v grep | awk '{print $2}' | xargs kill`.

### Cross-Cutting Patterns

#### Silent wrong-target writes (verify-after-action)

**Observed in:** personal-CRM-style project (silent wrong-page capture writing to correct Notion index — 5 entries corrupted), family-bike-routing project (router snapping to wrong directed island; bike-priority infra detour from speed-cap bug; kid-confident surface inversion). Also already-known from 2026-02 personal-CRM-style ("verify after slug match").

**Description:** Multiple projects this window hit silent-corruption-class bugs where the action took effect on a wrong target without raising an error. The unifying failure mode: the system kept going past a soft failure (empty URL, missing edge, mismatched classifier output), and the side-effect landed on the right index/key with the wrong payload. Tests against fixtures pass; tests against live data catch it.

**Reconciliation:** Existing `templates/rules/workflow-conventions.md` has a "live-data smoke test before handoff" pattern (from 2026-02-24 aggregation). The 2026-04-13 aggregation also flagged "Verify after slug match" as a personal-CRM-specific learning. The recurrence here suggests promoting it to a generic principle.

**Propagation:** **Hold for now — no obvious template change.** The principle is "verify the side-effect target after the action and treat boolean returns as load-bearing." That's project-shaped advice, hard to template generically. Better path: add to `learnings.md` in each project that does mutate-by-key (personal-CRM-style, blog-assistant, family-bike-routing) when relevant, and let the in-project review catch it. Re-evaluate next aggregation if it shows up in a third unrelated project.

---

#### Monotonicity / superset invariants in user-facing classifications

**Observed in:** family-bike-routing project (kid-confident must be surface superset of kid-starting-out — paving_stones inversion bug).

**Description:** When a UI exposes a tiered system (skill levels, severity tiers, access levels), the user's mental model is "higher tier = strict superset of lower tier." Breaking that invariant in the classifier creates visible-but-confusing inversions (toggling skill UP made things worse). Single project so far, but the pattern is general — anywhere a project has tiered classifications, an explicit monotonicity test is cheap insurance.

**Propagation:** **Single-project observation, hold.** Re-evaluate if it shows up in a second project (e.g., personal-finance risk tiers, health-tool symptom severity tiers).

---

#### Sparse-data filters create more harm than benefit

**Observed in:** family-bike-routing project (OSM `width` / `lanes` / `est_width` on cycleways too sparse to filter on).

**Description:** When an attribute is tagged on <10% of items, filtering on it creates visible inconsistency ("this 1.2m path is rejected but that unmarked one is fine?") with very little real impact on the output. Better to skip the filter entirely and revisit when coverage improves. Generalizable beyond OSM (e.g., user-tagged metadata in personal-CRM, optional fields in any data system).

**Propagation:** **Single-project observation, hold.** Worth adding to a future "data quality" rules section if it recurs.

---

#### Plugin scaffolding spawned without substantive learnings yet

**Observed in:** claude-live-feedback-plugin (initial scaffold 2026-04-17), weekly-review (initial scaffold 2026-04-19), ux-review-plugin (initial scaffold 2026-04-20).

**Description:** Three brand-new projects scaffolded from `templates/` in W2. All three have empty learnings.md / retrospective.md placeholders. Means the scaffolding workflow itself is being exercised heavily — the conductor's `/new-project` and template propagation are now the predominant activity, more than substantive cross-project pattern emergence.

**Propagation:** **No action — informational.** Worth tracking whether these projects produce substantive learnings in the next 2-week window or stay placeholder-only. If empty placeholders persist >2 aggregation cycles, consider whether the placeholder structure is too low-signal for the new-project flow.

---

### Recommendations for `/propagate`

**Nothing to propagate this cycle.** All cross-cutting patterns are either single-project observations or already-addressed by existing templates/plugins:

- "Verify after action" / silent wrong-target — already addressed in spirit by `templates/rules/workflow-conventions.md` live-data testing requirement; the new instances are project-specific shapes.
- Monotonicity invariants and sparse-data filters — single-project, not yet patterns.
- The `/ux-review` skill (propagated 2026-04-17) appears to be working — projects that touched UI in W2 (family-bike-routing) used it informally, no rework loops surfaced in retros.

The action this cycle is to **continue scaffolding the three new projects** through normal template propagation channels, not to push anything new out.

### Notes on coverage gaps

- **bike-tool** (~/dev/bike-tool): worktree not present locally. Now superseded by family-bike-routing per 2026-04-13 aggregation note. Consider removing from registry if it's truly retired.
- **booster-frontend / booster-backend**: worktrees not present locally; advisory engagement appears paused. Skip until re-engaged.
- **health-tool, openclaw-config, tasks, givewell-impact, blog-assistant, octoturtle-assistant, product-engineer, job-search, rare-disease-benchmark**: no new learnings or retros in window. These projects either weren't touched or didn't produce capturable learnings; nothing missed.

---

## 2026-04-13

First aggregation since 2026-02-24 — a ~50 day gap. Covers 8 projects with new content; `openclaw-config`, `booster-frontend`, and `booster-backend` contributed nothing (the two booster worktrees don't exist locally right now). Cloudflare Workers / Agent SDK headless-execution learnings from the retired product-engineer infrastructure were **deliberately excluded** — they were just retired from this metaproject's own `learnings.md` in PR #24 and should not propagate back in.

### Cross-Cutting Patterns

#### Notion MCP reliability — new failure modes

**Observed in:** tasks (2026-02-25, 2026-02-23), blog-assistant (2026-02-25, 2026-02-26, 2026-03-09)

**Description:** Three new failure patterns on top of the "retry first attempt" pattern from the 2026-02-24 aggregation:

- `replace_content_range` fails silently on large page updates — default to `replace_content`
- **Parallel Notion mutations are unreliable** — blog-assistant saw 8/9 parallel comment calls fail from text-matching ambiguity; sequential retries worked instantly. Sequentialize Notion writes.
- **`notion-fetch` ↔ `notion-update-page` URL format mismatch** — fetch returns URLs wrapped in `{{...}}` but update expects plain URLs + `<mention-page>` tags. Requires transformation between read and write.

**Reconciliation:** `templates/rules/notion-mcp.md` already exists from the 2026-02-24 pass with the first-attempt-retry pattern. These three new modes are additions, not contradictions.

**Propagation:** Append the three new failure modes to `templates/rules/notion-mcp.md`, then `/propagate` to all Notion-using projects.

---

#### Subagents (Task tool) have no WebSearch / WebFetch access

**Observed in:** tasks (Berlin apartment search abandoned after ~27 min; Windows laptop research; Toronto lawyer research)

**Description:** Background agents dispatched via the `Task` tool (and Agent Teams teammates) cannot call `WebSearch` or `WebFetch`. Projects that try to parallelize research via agent teams get stuck when a teammate needs to look something up. Keep web research in the main session; reserve subagents for synthesis, local-file reads, and non-web parallel work.

**Reconciliation:** Not documented in `templates/rules/workflow-conventions.md`'s Execution Strategy section. No existing rule covers it.

**Propagation:** Add a one-liner to `templates/rules/workflow-conventions.md` under Execution Strategy → Agent Team: *"Agent teams cannot use WebSearch/WebFetch. Keep web research in the main session."*

---

#### Grep-before-simplify as a refactor definition of done

**Observed in:** bike-tool (BC-258 SafetyClass simplification, 2026-04-03; Berlin hardcoded geocoding migration, 2026-04-04)

**Description:** When simplifying code or removing an abstraction, grep all usages first and treat "zero remaining usages + tests still pass" as the definition of done. When an abstraction maps 1:1 to a simpler primitive, flag the redundancy immediately instead of interpreting "simplify" as "reduce visible complexity." The SafetyClass simplification took 4 user prompts to converge because the agent kept trying to reduce visible complexity rather than questioning whether the abstraction belonged.

**Reconciliation:** Not in templates. `superpowers:subagent-driven-development`'s two-stage review catches some of this but doesn't explicitly require grep-before-refactor.

**Propagation:** **Emerging — only one project observed so far.** Not propagating yet. Re-evaluate next aggregation; if it shows up in a second project, add to `templates/rules/workflow-conventions.md`.

---

### Additional Project Observations

Project-specific learnings that don't yet rise to a cross-cutting pattern. Grouped by project; source files have the full context.

#### health-tool (since 2026-02-25)
- **Python / uv:** `uv sync --extra dev` required in new worktrees — pytest is in optional dev deps and new worktrees won't have them
- **Chrome extension URLs:** Can't screenshot or run JavaScript against `chrome-extension://` URLs — use `read_page` and `find` instead
- **Sound synthesis:** `tanhf()` soft saturation is cleaner than hard clipping for additive synthesis
- **Field testing catches what code review misses:** A DSP silence bug (tap on `outputVolume=0` node) only surfaced in field testing, not in review or unit tests
- **Process:** Check if a barrier is trivially removable before building a workaround
- **Parallel agent teams:** Two context-window hits during one large parallel run added ~30 min of overhead — plan for it
- **iOS audio routing:** AirPods + external Bluetooth speaker requires time-multiplexed session switching, not simultaneous output

#### bike-tool (since 2026-03-31)
- **Canvas rendering for perf:** React `<Polyline>` per OSM way is slow; `L.LayerGroup` + `L.canvas()` is 5–10× faster and still supports Leaflet tooltip hit-testing. Moving from JSX to string templates requires `escapeHtml()`
- **Tooling gotcha:** `bunx tsc --noEmit` downloads a wrong npm package literally named `tsc`. Use `bun test` + the project's local vite build instead
- **OSM bicycle tagging:** `bicycle_network >= 1` tests route membership, NOT `bicycle_road=yes`. Most Berlin Fahrradstrassen lack route membership and were silently misclassified — correct field is `edge.bicycle_road` boolean. Classification must be profile-aware: `classifyEdge(profileKey)`
- **Integration test drift:** Fixed thresholds like `quality.bad < 0.5` break after model improvements even when the change is good — re-tune after classification changes
- **Type annotations in subagent work:** Objects spread into string-keyed maps need explicit `Record<string, string>` typing, or subagents miss it and cause `URLSearchParams` errors
- **Data-first coding:** Posting the full classification table to Slack before writing code caught real inconsistencies (footway great vs good, share_busway training differences)
- **Cloudflare Worker secret layout:** Keeping proxy + feedback in one Worker keeps secrets co-located. A precision-6 polyline decoder requires a unit test — the 1e6 vs 1e5 constant is silent if wrong. No deployed test environment at PR time means secrets must be set up out-of-band
- **Valhalla `trace_attributes`** for segment coloring was the right tool

#### personal-crm (since 2026-03-01)
- **LinkedIn Voyager API intercept:** Capture full experience/education data from the main page load instead of scraping sub-pages
- **Top bot signals to defeat:** Predictable 3-page navigation, direct-URL goto with no referrer, zero feed/search activity, JS `window.scrollBy()`, linear mouse paths, zero keyboard activity, single tab
- **Realistic input events:** `page.mouse.wheel(0, N)` fires real `wheel` DOM events; `page.mouse.move()` is linear — interpolate with cubic bezier for natural paths
- **Verify after slug match:** Check `page.url` after a slug-based substring match — scraping the wrong profile is silent otherwise
- **Planning wins:** A detailed plan enabled 7 tasks across 3 batches with only 2 user interactions; the code review subagent caught 7 real issues (wrong-profile click, infinite scroll, dead code, missing tests) before PR

#### tasks (since 2026-02-25)
- **Agent teams for research:** Debate / challenge structures surface nuanced findings (Windows laptop review caught X1 Carbon OLED coating nuance, Surface Laptop 7 return rates, Adobe InDesign ARM failures). But ~50% of turns can be idle-notification acknowledgments — this is normal noise, not a failure signal
- **Domain gotcha — German real estate:** "2-Zimmer" = 2 rooms total (1 bedroom + living room), NOT 2 bedrooms. Need "3-Zimmer" for a true 2-bedroom. "Kernsaniert Altbau" still carries mold risk
- **Brainstorming criteria up front:** A 5-question Q&A before research shapes the effective criteria and prevents mid-session redirects
- **ImmoScout blocks WebFetch** (specific instance of the subagent web-tool limitation flagged above)
- **Research iteration:** Logistical constraints (availability, timeline, display baseline) often surface only after a v1 and require a full re-research — assume iteration, don't expect one-shot

#### givewell-impact (since 2026-03-05)
- **Satori / OG image generation:** No variable fonts (use static TTF), no `dotted` border, flexbox-only layout, inline styles only (no Tailwind), `Buffer.buffer` can return `SharedArrayBuffer` (create a fresh `ArrayBuffer` and copy via `Uint8Array`), font CDN URLs go stale — commit TTFs or pin a versioned path
- **Next.js scaffolding:** `create-next-app` refuses to run in a non-empty directory — scaffold to `/tmp/...`, then move
- **Visual sign-off:** Interactive HTML mockups in a browser are dramatically faster than ASCII art for design approval
- **Plans should specify API input validation explicitly** — spec quality review catches missing validation only if the plan mentions it

#### blog-assistant (since 2026-02-25)
- **Editorial feedback that lands:** Structural / flow / factual review works; prose rewrite suggestions consistently miss voice — let the author rewrite
- **Notion + WordPress image handoff:** Notion images use temporary signed S3 URLs that expire within hours — can't auto-transfer to WordPress
- **Concurrent edit collision:** WordPress browser editor overwrites API edits if the user has the post open in the editor
- **Suggested Edits feature not available via API/MCP** (as of Feb 2026)
- **Cold-start MCP latency dominates active time** — one editorial pass was 39 min of 65 min spent on Notion MCP round trips
- **Source verification as a background agent caught a real issue** (ICER source didn't back the claim) — worth running even when sources look solid

#### octoturtle-assistant (since 2026-03-24)
- **Map usability for kid routes:** Pre-attentive processing is the design bar — high contrast, bold colors, distinct patterns, large icons. Official maps (CyclOSM, InfraVelo, BBBike, ADFC) with subtle shading fail for glance-while-biking. Bright green thick lines for car-free, orange for protected, gray/red for avoid
- **OSM data quality:** ±2–30% concordance with official data for urban/rural bicycle infrastructure; known gaps in car-free park paths, parent-specific context, surface quality. Tools: Overpass Turbo, Bicycle Tags Map, ID/JOSM editors
- **German rail discovery:** DB does NOT surface ČD-operated EC/RJ trains for domestic German boarding (Prague–Berlin corridor) — cross-reference with czech-transport.com, vagonweb.cz, DB/cd.cz/ÖBB/Trainline. Helix folding bikes travel free as luggage (58×64×23 cm folded). Deutschland-Ticket covers regional only, NOT IC/ICE/EC/RJ
- **Deliverable placement:** Research deliverables go to Notion, not `docs/product/plans/`. The repo is only agent config, process learnings, and decisions

---

### Recommendations for `/propagate`

1. **Append new Notion MCP failure modes** to `templates/rules/notion-mcp.md` (3 new flavors from Cross-Cutting Patterns above). Then `/propagate` to all projects that use Notion MCP: health-tool, bike-tool, personal-crm, tasks, givewell-impact, blog-assistant, octoturtle-assistant, family-bike-map.

2. **Add subagent web-tool limitation** to `templates/rules/workflow-conventions.md` under Execution Strategy → Agent Team. One-liner. Then `/propagate` to all projects using Agent Teams (especially tasks).

3. **Do not propagate grep-before-simplify yet** — single-project observation. Revisit next aggregation.

4. **Family-bike-map vs bike-tool duplication:** family-bike-map contributed zero net new content this pass — its retros duplicate bike-tool's (same work, two repos). Consider whether to (a) symlink one retros file to the other, (b) rename family-bike-map's repo as the canonical one, or (c) accept the duplication. Flag for Bryan — not a propagation action.

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
