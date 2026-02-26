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
- `mcp__github__push_files` cannot access private repos — skip straight to `git clone` + write files + `git push` for private repos.

## Propagation
- Always use worktrees when making changes to target projects — never edit the main worktree directly
- Bundle all related changes into one commit and one PR per project, not one per artifact
- When updating existing project files, diff the template against the current version and apply only additions — don't replace the file wholesale, or you'll clobber project-specific customizations

## Retros
- Don't use AskUserQuestion for retro feedback. Just pose the questions as plain text in the conversation and let the user type naturally. Structured question tools feel like a survey and force the user to answer everything at once.
- The transcript finder must filter by project path, not just recency. With multiple Conductor worktrees running in parallel, globbing all `**/*.jsonl` by modification time will pick up the wrong session.
- The Skill tool is synchronous — it can't run "in parallel" or "in the background." To run skill-like work in parallel, use a Task agent with explicit instructions instead.
- Use `templates/scripts/analyze-transcript.sh` for transcript analysis — don't write custom Python or delegate to a subagent for JSONL parsing. The script uses jq+awk, needs no authorization, and handles system message filtering, turn melding, and hands-on time calculation deterministically.

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
- `mcp__github__push_files` returns 404 on a brand-new repo with no commits (no default branch exists yet). Workaround: clone the repo locally, make an empty init commit, push to create `main`, then use local git for all subsequent file operations.

## Working with Users
- When the user says "set up X for the team," they often mean adoption guidance (how to install, how to use), not config files to commit. Ask which they mean if ambiguous.
- Short, direct user corrections ("don't bury the lede", "stop mentioning feature chains") are the most productive feedback. Don't over-explain in response — just fix it.
