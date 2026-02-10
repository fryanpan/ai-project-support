# Learnings

Technical discoveries that should persist across sessions.

## Template Management
- When deleting or renaming template artifacts, grep the entire repo for references before committing — skills, docs, and use-cases may all reference them. The code review for PRJ-2 caught stale references in `new-project/SKILL.md`, `update-project/SKILL.md`, and `docs/product/use-cases.md` after the PR was already created.
