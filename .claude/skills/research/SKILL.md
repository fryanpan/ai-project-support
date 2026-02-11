---
name: research
description: Research the latest techniques and tools for AI-assisted development. Covers Claude Code, Codex, community tools (GSD, Autoclaude, aider, cursor), and engineering discourse (HN, blogs). Run with a specific topic or use the default watchlist.
argument-hint: "[topic or 'watchlist']"
user-invocable: true
---
# Research Agent Techniques & Tools

Stay current on the latest approaches to AI-assisted development and evaluate them for adoption.

## Default Watchlist

When invoked without a specific topic (or with `watchlist`), research these areas:

1. **Claude Code** — Anthropic docs/changelog, new features, best practices (docs.anthropic.com, anthropic.com/blog)
2. **Codex** — OpenAI's agent coding tool, updates and comparisons
3. **Community Tools** — GSD, Autoclaude, aider, cursor, windsurf, cline, and similar tools
4. **GitHub Trending** — Trending repos in AI-assisted development, agent frameworks
5. **Engineering Discourse** — Hacker News, engineering blogs, Twitter/X threads on agent workflows

## Steps

1. **Determine scope**: If `$ARGUMENTS` is a specific topic, research that. Otherwise, work through the watchlist.

2. **Search and fetch**:
   - Use `WebSearch` to find recent articles, docs, release notes, discussions
   - Use `WebFetch` to read the most relevant pages
   - Focus on what's **new since the last research** — check `research/topics/` for existing findings and their dates

3. **Write findings** to the appropriate location:
   - **Ongoing topic**: Update `research/topics/{topic-slug}.md` with new findings appended under a date header
   - **New tool/technique evaluation**: Create `research/evaluations/{YYYY-MM-DD}-{tool-name}.md`

   Each finding should include:
   - **What it is** — brief description
   - **What's new** — recent changes or developments
   - **Applicability** — which of our projects could benefit and how
   - **Effort to adopt** — what would need to change (S/M/L)
   - **Source URLs** — links to the original content

4. **Commit** the research file with message: `research: [topic slug] findings`

5. **Assess actionability**: For each finding that could improve our projects:
   - Note which projects would benefit
   - Describe what would need to change (skill update, new tool, workflow change)
   - Rate priority (do now / explore later / watch)

6. **Summarize** for the user:
   - Key findings and what's worth acting on
   - Recommend specific `/propagate` actions if applicable
   - Flag anything that needs user decision (e.g., "Should we try tool X on bike-tool?")
