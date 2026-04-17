# UX Evaluation Tooling for LLM Agents

**Date:** 2026-04-17
**Trigger:** Bryan's frustration with rework loops on UI work — agents ship something, he reviews in prod, sends it back. Diagnosis: agents have no model of how a user perceives, navigates, or completes goals on a page.

## The cognitive stack we want

A real UX evaluator reasons through:
1. **Mental model** — what's in the user's head when they land? What do they expect?
2. **Visual flow** — how does the eye move? F-pattern, Z-pattern, attention hierarchy
3. **Motor / interaction friction** — Fitts's Law, click targets, touch zones, keyboard nav
4. **Heuristic check** — Nielsen's 10, WCAG, dark patterns, etc.
5. **Goal completion** — can the user actually finish what they came to do, easily and correctly?

Nothing in the current Claude Code ecosystem covers all five. The pieces:

## What exists today

### Frontend-design (official Claude plugin) — NOT a UX tool
The `frontend-design` skill is purely about visual distinctiveness: bold typography, color, motion, asymmetric layouts, "make it UNFORGETTABLE." It explicitly optimizes for memorable, not effortless. Zero usability content. **This is the source of confusion** — agents reach for it thinking it'll help with UX, but it actively works against simplicity.

### Heuristic skills (knowledge injections, no tools)
- **`mastepanoski/claude-skills`** — three relevant skills:
  - `nielsen-heuristics-audit` — takes a URL/screenshot/code, returns severity-scored heuristic findings
  - `wcag-accessibility-audit`
  - `ux-audit-rethink`
  - Install: `npx skills add mastepanoski/claude-skills --skill nielsen-heuristics-audit`
- **`szilu/ux-designer-skill`** — comprehensive UX/UI guidance, Gestalt principles, interaction hierarchy

These give the agent a reasoning framework. They don't observe real behavior — the agent has to look at code/screenshots and reason from principles.

### MCP servers for accessibility (real automated scans)
- **Deque axe MCP** (`dequelabs/axe-mcp-server-public`) — wires axe DevTools into Claude Code. Analyzes live URLs against WCAG 2.1/2.2. Requires axe DevTools subscription for full power.
- **a11y-mcp-server** (community, free) — `npx -y a11y-mcp-server`. Same idea, no subscription.
- **`elsahafy/ux-mcp-server`** — broader: 28 UX knowledge resources, 23 tools including `detect_dark_patterns`, `analyze_information_architecture`, `calculate_ux_metrics`. Covers Nielsen + WCAG + design system patterns + e-commerce flows.

These catch technical issues (motor friction via inaccessible targets, keyboard nav failures, contrast problems). They don't reason about whether the layout makes sense.

### Browser automation for goal-completion testing
We already have `claude-in-chrome`. The practical pattern: agent navigates as a fresh user, screenshots key states, tries to complete the goal, evaluates against a heuristic checklist. **This is the closest thing to actual usability testing** — it's a workflow, not a tool. Our `/ux-review` skill is built on this pattern.

### UXAgent (Amazon Science, CHI 2026) — research-grade
Paper: arxiv 2502.12561

Generates **thousands of simulated user personas** that drive a real browser to test a design. Each persona has different demographics, goals, tech literacy, attention spans. Records behavioral traces. Output: "60% of users tried to click the title looking for navigation; only 25% found the actual button."

**Why we're not using it yet:** research code, not packaged. Own infrastructure (simulator framework, persona generation pipeline, browser automation). 1-2 days of setup minimum, research-y output format. **Worth revisiting** when someone packages it for production use, or for very high-stakes UI work where it's worth the setup cost.

## What doesn't exist

No tool yet models the full cognitive stack. Specifically:
- No tool reasons about F-pattern vs Z-pattern eye-tracking from a screenshot
- No tool simulates "what would a user expect this to do before they read carefully"
- No tool integrates the persona-driven simulation (UXAgent) into a Claude Code workflow

That cognitive reasoning lives in the LLM weights and has to be elicited through well-crafted prompts (which is what `/ux-review` does).

## Decisions for now

1. **Built `/ux-review` skill** (`templates/skills/ux-review/`) — wraps `claude-in-chrome` to walk a feature as a fresh user, evaluates against Nielsen's 10 + Fitts + visual hierarchy + goal-completion. Outputs a severity-scored report. **Goal: break the rework loop by making the agent do the prod-walkthrough Bryan currently does manually.**

2. **Not adding axe MCP yet** — would help, but the bigger gap is "did the agent walk the page at all." Add later as an automated pass under `/ux-review`.

3. **Not adding heuristic skills as separate plugins** — the heuristic checklist is inlined into `/ux-review` so the workflow is a single invocation, not "run skill A then skill B."

4. **UXAgent: revisit later.** Worth a deeper look if `/ux-review` proves valuable but doesn't catch enough — UXAgent's persona variation is the missing piece. Specifically worth a half-day investigation to:
   - Read the paper end-to-end
   - Check if there's a usable demo/repo
   - Estimate cost of running it on a typical bike-map-sized UI
   - Decide if it's worth packaging as a Claude Code workflow

## Sources

- [mastepanoski/claude-skills — Nielsen Heuristics, WCAG, UX Audit skills](https://github.com/mastepanoski/claude-skills)
- [Deque axe MCP Server — official WCAG testing for Claude Code](https://www.deque.com/axe/mcp-server/)
- [a11y-mcp-server — community free axe alternative](https://github.com/ronantakizawa/a11ymcp)
- [elsahafy/ux-mcp-server — 28 UX knowledge resources](https://github.com/elsahafy/ux-mcp-server)
- [UXAgent — Amazon Science usability framework (CHI 2026)](https://www.amazon.science/publications/uxagent-an-llm-agent-based-usability-testing-framework-for-web-design)
- [UX Heuristics Skill for Claude Code — mcpmarket listing](https://mcpmarket.com/tools/skills/ux-heuristics-framework)
