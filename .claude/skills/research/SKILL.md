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

2. **Spawn a research team**: Create an agent team and divide the research into focused angles — by sub-question, source type, or tool category — one teammate per angle. For the **watchlist**, assign one open question per teammate. Each teammate independently researches their angle (steps 3–6 below), then the team runs a debate round (step 7) before the lead synthesizes (step 8).

3. **Search broadly** *(each teammate, for their assigned angle)*:
   - Use `WebSearch` to find how people are solving this problem — blog posts, HN discussions, tool docs, community threads
   - Use `WebFetch` to read the most relevant pages
   - Look across categories: Claude Code features, community tools (GSD, Autoclaude, aider, cursor, etc.), workflow patterns, agent frameworks
   - Focus on what's **new since the last research** — check `research/` for existing findings and their dates

4. **Assess fit before writing** *(lead, before teammates write)*: Determine whether the findings belong in this repo or somewhere else.

   Ask yourself:
   - Does this research affect how the **metaproject** works — templates, skills, conventions, or tool choices that would influence how Claude Code projects are set up?
   - Or is it driven by a **personal use case** (specific tasks, personal domains like health/finance/networking)?

   If it's personal, **ask the user where to put it** before writing anything:
   > "This research is specific to [your personal use case]. It doesn't belong in the public metaproject repo. Should I save it to `~/dev/research-notes/` instead?"

   Wait for the user's answer. They may redirect to research-notes, health-tool, personal-finance, or somewhere else.

   If it belongs here, teammates write to `research/{YYYY-MM-DD}-{topic-slug}-{angle}.md`.

5. **Write findings** *(each teammate, if confirmed to belong here)* to `research/{YYYY-MM-DD}-{topic-slug}-{angle}.md`.

   Each finding should include:
   - **Problem it addresses** — what pain point or outcome does this help with
   - **What it is** — brief description of the tool, technique, or approach
   - **How it works** — enough detail to evaluate fit
   - **Applicability** — which of our projects could benefit and how
   - **Effort to adopt** — what would need to change (S/M/L)
   - **Source URLs** — links to the original content

6. **Commit** *(each teammate)* the research file with message: `research: [topic slug] findings`

7. **Assess actionability** *(each teammate)*: For each finding that could improve our projects:
   - Note which projects would benefit
   - Describe what would need to change (skill update, new tool, workflow change)
   - Rate priority (do now / explore later / watch)

8. **Debate** *(teammates)*: Share findings with each other and **actively challenge each other's conclusions** — looking for gaps, contradictions, and overconfident claims. The lead orchestrates the exchange and waits for it to complete before synthesizing.

9. **Synthesize** *(lead)*: After the debate round, summarize for the user:
   - What the team found and how it addresses the original problem
   - For single-topic research, consolidate angle files into `research/{YYYY-MM-DD}-{topic-slug}.md`
   - Recommend specific `/propagate` actions if applicable
   - Flag anything that needs a user decision
