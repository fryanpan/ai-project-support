# Learnings

Technical discoveries that should persist across sessions.

## Template Management
- When deleting or renaming template artifacts, grep the entire repo for references before committing — skills, docs, and use-cases may all reference them. The code review for PRJ-2 caught stale references in `new-project/SKILL.md`, `update-project/SKILL.md`, and `docs/product/use-cases.md` after the PR was already created.

## Plan Mode
- Skip plan mode for simple deliverables (writing a doc, creating a ticket, small edits). Plan mode adds ~6 min overhead and is only worth it for multi-file implementation work.

## Retros
- Don't use AskUserQuestion for retro feedback. Just pose the questions as plain text in the conversation and let the user type naturally. Structured question tools feel like a survey and force the user to answer everything at once.

## Project Reviews
- Lead with findings, not recommendations. The most interesting thing is what we learned about the team, not what we think they should do.
- Don't invent jargon ("feature chains") — use plain language ("features") and define terms when needed.
- Be less certain in tone when proposing changes — "worth trying" not "this will work." We're proposing things to try, not prescribing solutions.
- Check existing infrastructure before proposing new things. The Booster backend already had `make test-base` with ~150-200 non-DB tests — proposing a new `tests/fast/` directory was unnecessary.
- Bryan's reorganized Booster Review Notes page is a good template: How We Reviewed → Key Findings → What They Already Have → Proposed Workflow → How To Make It Work → Detailed Notes (subpages).

## Notion MCP
- `allow_deleting_content: true` on `replace_content` will archive child pages that were embedded in the old content. This is destructive and hard to undo — user had to manually restore pages from Notion trash. Avoid this flag; use `replace_content_range` or `insert_content_after` instead.
- When replacing content on a page with child pages, always preserve `<page url="...">` tags in the new content to avoid archiving them.

## Working with Users
- When the user says "set up X for the team," they often mean adoption guidance (how to install, how to use), not config files to commit. Ask which they mean if ambiguous.
- Short, direct user corrections ("don't bury the lede", "stop mentioning feature chains") are the most productive feedback. Don't over-explain in response — just fix it.
