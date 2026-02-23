---
name: research
description: Research a pain point, workflow friction, or desired outcome in AI-assisted development. Finds tools, techniques, and approaches that address it. Run with a problem statement or use the default watchlist of open questions.
argument-hint: "[pain point, outcome, or 'watchlist']"
user-invocable: true
---
# Research Pain Points & Outcomes

Research a specific pain point or desired outcome in AI-assisted development. The goal is to find what tools, techniques, or workflow changes would address it — not to evaluate a pre-chosen tool.

## Default Watchlist

When invoked without a specific topic (or with `watchlist`), research these open questions:

1. **How do you keep multiple projects in sync?** — Template propagation, shared config, cross-project automation
2. **How do you onboard non-technical users?** — Entry points, guardrails, how much Claude should explain vs. decide
3. **How do you get feedback loops working?** — Retros, transcript analysis, automated improvement
4. **How do you reduce setup friction?** — Scaffolding, one-command project creation, sensible defaults
5. **What's changing in the ecosystem?** — New capabilities in Claude Code, Codex, community tools, agent frameworks

## Steps

1. **Understand the problem**: If `$ARGUMENTS` is a specific pain point or outcome, start from that. Frame it as a question — "How do I...?" or "What would help with...?" Don't start from a tool name.

2. **Search broadly**:
   - Use `WebSearch` to find how people are solving this problem — blog posts, HN discussions, tool docs, community threads
   - Use `WebFetch` to read the most relevant pages
   - Look across categories: Claude Code features, community tools (GSD, Autoclaude, aider, cursor, etc.), workflow patterns, agent frameworks
   - Focus on what's **new since the last research** — check `research/` for existing findings and their dates

3. **Assess fit before writing**: Determine whether the findings belong in this repo or somewhere else.

   Ask yourself:
   - Does this research affect how the **metaproject** works — templates, skills, conventions, or tool choices that would influence how Claude Code projects are set up?
   - Or is it driven by a **personal use case** (specific tasks, personal domains like health/finance/networking)?

   If it's personal, **ask the user where to put it** before writing anything:
   > "This research is specific to [your personal use case]. It doesn't belong in the public metaproject repo. Should I save it to `~/dev/research-notes/` instead?"

   Wait for the user's answer. They may redirect to research-notes, health-tool, personal-finance, or somewhere else.

   If it belongs here, write to `research/{YYYY-MM-DD}-{topic-slug}.md`.

4. **Write findings** (if confirmed to belong here) to `research/{YYYY-MM-DD}-{topic-slug}.md`.

   Each finding should include:
   - **Problem it addresses** — what pain point or outcome does this help with
   - **What it is** — brief description of the tool, technique, or approach
   - **How it works** — enough detail to evaluate fit
   - **Applicability** — which of our projects could benefit and how
   - **Effort to adopt** — what would need to change (S/M/L)
   - **Source URLs** — links to the original content

5. **Commit** the research file with message: `research: [topic slug] findings`

6. **Assess actionability**: For each finding that could improve our projects:
   - Note which projects would benefit
   - Describe what would need to change (skill update, new tool, workflow change)
   - Rate priority (do now / explore later / watch)

7. **Summarize** for the user:
   - What you found and how it addresses the original problem
   - Recommend specific `/propagate` actions if applicable
   - Flag anything that needs a user decision
