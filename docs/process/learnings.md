# Learnings

Technical discoveries that should persist across sessions.

## Template Management
- When deleting or renaming template artifacts, grep the entire repo for references before committing — skills, docs, and use-cases may all reference them. The code review for PRJ-2 caught stale references in `new-project/SKILL.md`, `update-project/SKILL.md`, and `docs/product/use-cases.md` after the PR was already created.

## Plan Mode
- Skip plan mode for simple deliverables (writing a doc, creating a ticket, small edits). Plan mode adds ~6 min overhead and is only worth it for multi-file implementation work.

## Skill Editing
- When inserting a step into a numbered skill list, renumber all subsequent steps in a single edit rather than one-at-a-time — cascading individual edits are error-prone and slow

## Propagation
- Always use worktrees when making changes to target projects — never edit the main worktree directly
- Bundle all related changes into one commit and one PR per project, not one per artifact
- When updating existing project files, diff the template against the current version and apply only additions — don't replace the file wholesale, or you'll clobber project-specific customizations

## Retros
- Don't use AskUserQuestion for retro feedback. Just pose the questions as plain text in the conversation and let the user type naturally. Structured question tools feel like a survey and force the user to answer everything at once.
