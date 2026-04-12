# Learnings

Technical discoveries that should persist across sessions.

## Template Management
- When deleting or renaming template artifacts, grep the entire repo for references before committing — skills, docs, and use-cases may all reference them. A code review once caught stale references in skill files and `docs/product/use-cases.md` after the PR was already created.

## Plan Mode
- Skip plan mode for simple deliverables (writing a doc, creating a ticket, small edits). Plan mode adds ~6 min overhead and is only worth it for multi-file implementation work.

## Skill Editing
- When inserting a step into a numbered skill list, renumber all subsequent steps in a single edit rather than one-at-a-time — cascading individual edits are error-prone and slow

## Project Setup
- When setting up new projects, do the work in the main thread using this repo's templates and skills — don't delegate to subagents. Subagents can't access project skills (`/propagate`, `/new-project`), struggle with cross-repo file access, and end up reinventing what the skills already do.
- Multi-repo setup burns through context fast (2 compactions in ~90 min). Commit between repos to preserve progress — if context runs out mid-session, uncommitted work in earlier repos is safe.
- Use `gh` CLI and local git for all GitHub operations — the GitHub MCP plugin doesn't work reliably (can't access private repos, 404s on new repos with no commits, etc.).

## Propagation
- Always use worktrees when making changes to target projects — never edit the main worktree directly
- Bundle all related changes into one commit and one PR per project, not one per artifact
- When updating existing project files, diff the template against the current version and apply only additions — don't replace the file wholesale, or you'll clobber project-specific customizations

## Retros
- Don't use AskUserQuestion for retro feedback. Just pose the questions as plain text in the conversation and let the user type naturally. Structured question tools feel like a survey and force the user to answer everything at once.
- The transcript finder must filter by project path, not just recency. With multiple Conductor worktrees running in parallel, globbing all `**/*.jsonl` by modification time will pick up the wrong session.
- The Skill tool is synchronous — it can't run "in parallel" or "in the background." To run skill-like work in parallel, use a Task agent with explicit instructions instead.
- Use `analyze_transcript.py` (lives in the retro skill directory) for transcript analysis — don't write custom scripts or delegate to a subagent for JSONL parsing. The script is pure Python (stdlib only), needs no authorization when called from the skill directory, and handles system message filtering, overlapping turn merging, and hands-on time calculation deterministically. Tests in `tests/test_analyze_transcript.py`.
- For cross-session analysis (e.g., finding intervention patterns across many sessions), build on top of `analyze_transcript.py` by importing `extract_messages()` and `group_into_turns()` — don't rewrite JSONL parsing from scratch. Layer additional analysis (correction detection, permission patterns) on the properly parsed turns.

## Artifact Placement
- Decide where an artifact lives before writing it — local file, Notion, or another repo. Switching mid-stream (write locally → delete → rewrite to Notion → create a new repo) costs ~10 min and creates unnecessary git noise.

## Project Reviews
- Lead with findings, not recommendations. The most interesting thing is what we learned about the team, not what we think they should do.
- Don't invent jargon ("feature chains") — use plain language ("features") and define terms when needed.
- Be less certain in tone when proposing changes — "worth trying" not "this will work." We're proposing things to try, not prescribing solutions.
- Check existing infrastructure before proposing new things. One project already had `make test-base` with ~150-200 non-DB tests — proposing a new `tests/fast/` directory was unnecessary.
- A good structure for review notes: How We Reviewed -> Key Findings -> What They Already Have -> Proposed Workflow -> How To Make It Work -> Detailed Notes (subpages).

## Notion MCP
- `allow_deleting_content: true` on `replace_content` will archive child pages that were embedded in the old content. This is destructive and hard to undo — user had to manually restore pages from Notion trash. Avoid this flag; use `replace_content_range` or `insert_content_after` instead.
- When replacing content on a page with child pages, always preserve `<page url="...">` tags in the new content to avoid archiving them.

## Brainstorming
- When the user has already described the problem space clearly in a prior invocation (e.g., a detailed /new-project request), fast-track to proposing a first-cut design after 1-2 targeted questions — don't run the full clarifying sequence. The user will feel like they're repeating themselves if you ask about things they already covered.

## GitHub API
- For brand-new repos with no commits: clone locally, make an initial commit, then push to create `main`.

## Aggregate Workflow
- When reviewing aggregate outputs, GitHub PR diff comments are an effective async review pattern — the agent can address all comments in a single follow-up pass without back-and-forth
- When proposing propagation actions in `docs/process/aggregation-log.md`, reconcile against: (1) what `templates/` already contains, (2) what the propagation log shows, and (3) what shared plugins (e.g., superpowers) already cover — learnings from older retros may predate major tooling changes and recommend fixes that are now redundant

## Tooling
- The `Write` and `Edit` tools require a file to have been read "recently" in the same session — if many tool calls have elapsed since the initial read, re-read the file immediately before writing/editing to avoid "file not read yet" errors

## Working with Users
- When the user says "set up X for the team," they often mean adoption guidance (how to install, how to use), not config files to commit. Ask which they mean if ambiguous.
- Short, direct user corrections ("don't bury the lede", "stop mentioning feature chains") are the most productive feedback. Don't over-explain in response — just fix it.
- Before building a tool or script, ask the user about language preference and testing expectations. Don't assume bash is fine — the user may strongly prefer Python (for testability) or another language. A 30-second question saves a full rewrite.

## Python Environment
- When `python3` commands fail with permission errors or missing packages, check whether a version manager (uv, pyenv) is installed before retrying. `which uv && uv python list` or `which pyenv && pyenv versions` diagnoses the issue faster than repeated shell attempts.

## Git Hard Links
- Git does not preserve hard links across checkouts. When two files share an inode (e.g., a script hard-linked into two skill directories), `git checkout` replaces them with independent copies. Track both files in git and accept they'll diverge — or use a symlink if one canonical location is acceptable.

---
## Conductor & Agent System

Learnings from building and operating the product-engineer autonomous conductor (Cloudflare Workers + Containers + Claude Agent SDK). Carried over 2026-04-13 when retiring that infrastructure.

## Agent SDK (Headless Execution)
- `ExitPlanMode` / `EnterPlanMode` require interactive user approval. In headless execution (no TTY), the agent hangs forever waiting. **Always ban plan mode** in headless agent prompts.
- `AskUserQuestion` also hangs headless — redirect to an MCP tool that posts to Slack instead.
- `bypassPermissions` mode fails when running as root. The SDK checks `process.getuid()` and refuses. Run containers as a non-root user.
- `settingSources: ["project"]` loads CLAUDE.md, all `alwaysApply: true` rules from `.claude/rules/`, and skills from `.claude/skills/` in the target repo. Interactive-only alwaysApply rules (feedback prompts, retro offers, frustration detection) silently waste agent context tokens on every turn. Fix the target repos' rules to be headless-compatible.

## Agent SDK (Plugins in Headless Mode)
- `settingSources: ["project"]` does NOT load `enabledPlugins` from `.claude/settings.json`. Plugins must be passed explicitly via the `plugins` query option.
- The SDK `plugins` option only supports `{ type: "local", path: "..." }` — no marketplace resolution. The agent must clone marketplace repos and resolve paths itself.
- `claude plugin install` requires full CLI with OAuth login — not usable in headless containers. Shallow-clone the marketplace GitHub repo directly (`anthropics/claude-plugins-official`).
- Marketplace repos use `.claude-plugin/marketplace.json` as the plugin index. URL-sourced entries (e.g., superpowers from `obra/superpowers`) require a separate git clone.
- Plugin loading should be non-fatal: if cloning fails, the agent continues without plugin skills.

## Agent Cost Optimization
- Cache reads dominate cost at ~72% of total spend. At ~70K cached tokens/turn, cost is ~$0.02-0.03/turn for Sonnet. Reducing turns matters more than reducing prompt size.
- **Implementation subagent pattern**: dispatching the coding phase as a subagent via the `Agent` tool gives it fresh ~20K context vs the parent's growing 100K+ history — 84% cheaper per turn. With ~25 implementation turns/task, this is the single biggest cost lever.
- **Haiku for CI monitoring**: polling CI in a Haiku subagent (87% cheaper cache reads vs Sonnet: $0.04/MTok vs $0.30/MTok) is appropriate for low-intelligence retry loops.
- Subagents dispatched via the `Agent` tool do NOT inherit the parent's custom MCP servers. Use standard tools (`gh pr checks` via Bash) for CI status.
- Total alwaysApply content across all rules in a target repo should be < 80 lines.

## Task Review Decision Engine
- **Default to action, not questions.** For Slack-originated requests, the bar for asking is VERY high. The user already took action to mention the bot — they expect work to start, not a questionnaire.
- Only ask if BOTH: (1) genuinely ambiguous about WHAT to do (not HOW), and (2) cannot be determined by reading code/comments/links.
- Prompt guidance must be specific and concrete. "Prefer X unless Y" is too vague — use explicit decision criteria + concrete examples.

## Multi-Agent Lifecycle
- Guard against restarting completed/terminal tasks from alarms — this pattern caused bugs twice. Always check terminal state at the top of any periodic handler.
- **Lifecycle fixes need both forward-looking prevention AND retroactive cleanup.** Implement: (1) fix for future instances, (2) cleanup for existing broken instances, (3) deploy both together. Fixing only new instances leaves pre-existing stuck agents running forever.
- Multi-agent features have many edge cases: deploy resume, terminal state, alarm restarts. Plan with explicit edge case enumeration before implementing.

## GitHub Fine-Grained PATs
- Fine-grained PATs do NOT have a "Checks" permission. The check-runs API (`/repos/.../commits/.../check-runs`) is inaccessible. Use the commit statuses API (`/repos/.../commits/.../status`) instead, which requires "Commit statuses: Read" permission.
- Never use the check-runs API in code that runs with fine-grained PATs.

## GitHub Webhooks
- GitHub PR webhooks have `action: "closed"` with a `merged: true|false` flag. Handle BOTH cases: `merged === true` → PR merged; `merged === false` → PR closed without merging. Only handling the merged case leaves closed-but-not-merged PRs stuck forever.
- Terminal webhook events (`pr_merged`, `pr_closed`) must update state directly — don't route them to the agent container, which may have already exited.

## CI Workflow & Multi-PR Coordination
- CI triggers on `pull_request` events only (not `push`). Pushes to feature branches do not trigger CI — only opening or synchronizing a PR against `main` does.
- When merging multiple PRs that touch the same repo, rebase sequentially — merging one changes the base and creates conflicts in the others.

## Slack Bot Self-Mention Limitation
- Slack does NOT fire `app_mention` events when a bot mentions itself. A message posted by `xoxb-` bot token containing `<@BOT_USER_ID>` will not trigger Socket Mode delivery.
- E2E tests that need to simulate user mentions must use the internal endpoint directly or a separate user OAuth token.

## Slack Thread Routing
- Thread reply routing must use the original top-level message `ts` as the key, not a reply `ts` — otherwise a new task is created instead of routing to the existing one.
- For new `app_mention` events, `slackEvent.ts` (not `thread_ts`) is the canonical thread key. Subsequent replies arrive with `thread_ts` matching that original `ts`.

## Linear Webhook Integration
- Always use optional chaining on config fields: `config.triggers?.linear?.enabled` not `config.triggers.linear.enabled`. One missing `?` caused a 500 on every Linear webhook, which made Linear stop delivering after repeated failures.
- Linear stops delivering webhooks after repeated 500 errors. Fix: delete and recreate the webhook.
- `LINEAR_WEBHOOK_SECRET` must be synced between the Linear webhook config and the worker secret — verify the values match after any rotation.

## Bun Test Mock Isolation
- `mock.module()` in bun:test is **process-global** and persists across all test files in the same run. Never use `mock.module()` for modules that other test files also test.
- `globalThis.fetch` replacement leaks across test files unless explicitly restored. Use `spyOn(globalThis, "fetch")` with `mockRestore()` in `afterEach` instead.
