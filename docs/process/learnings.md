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
