# Retrospectives

Session retrospectives and process improvements.

## 2026-02-22 - Scaffold personal-crm project

### Time Breakdown
| Started | Phase | 👤 Hands-On | 🤖 Agent | Problems |
|---------|-------|------------|---------|----------|
| Feb 22 9:15pm | Setup + Q&A (type request, read clarifying questions, answer) | ██ 2.5m | | |
| Feb 22 9:20pm | Build (read templates, create repo + Linear, scaffold 11 files, push) | | █ 8m | ⚠ `mcp__github__push_files` failed twice for private repo, fallback to `git clone` |
| Feb 22 9:49pm | Final review + retro invocation | █ 1m | <1m | |

### Metrics
| Metric | Duration |
|--------|----------|
| Active wall-clock | ~12 min |
| Hands-on | ~5 min (42%) |
| Agent time | ~8 min (67%) |
| Retro analysis time | ~3 min |

### Key Observations
- Clear initial spec = no back-and-forth; Q&A answered in one message
- Research work offloaded to the project itself (happening now in personal-crm workspace)
- `mcp__github__push_files` cannot access private repos — ~3.5 min wasted before falling back to `git clone` + write files via CLI

### Feedback
**What worked:** Smooth and fast setup. Clear spec needed minimal clarification. Bifurcation between one-off tasks and ongoing projects means future setups will be even faster.
**What didn't:** Hands-on time calculation was overcounting (raw gaps, not actual reading+typing time). Fixed in retro skill.

### Actions Taken
| Issue | Action Type | Change |
|-------|-------------|--------|
| Hands-on time overcounting | Update skill | `retro/SKILL.md` — replaced gap-based counting with per-message reading + typing time (60 wpm) |
