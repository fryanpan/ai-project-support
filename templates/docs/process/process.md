# How We Work

## Deployment Workflow
1. Make changes locally
2. Test thoroughly
3. Push to a branch and open a PR — CI runs tests automatically
4. Merge to main

## When Adding Features
1. Discuss scope and approach (use `/plan` for non-trivial changes)
2. Implement with `/implement`
3. Test locally
4. Open PR, verify CI passes, merge
5. Log any non-obvious decisions in `docs/product/decisions.md`

## Session Continuity
- Reference `docs/product/decisions.md` before proposing alternatives to past decisions
- Reference `CLAUDE.md` for project conventions
- Read `docs/process/learnings.md` for technical gotchas
- Read `docs/process/retrospective.md` for process improvements

## Feedback Loops
- After completing a feature: Ask "Does this work? Anything to improve?"
- After ~2-3 hours or major feature: Run `/retro`
- Log insights in `docs/process/retrospective.md` and `docs/process/learnings.md`
