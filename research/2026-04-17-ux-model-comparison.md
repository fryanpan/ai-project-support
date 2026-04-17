# LLM Comparison for UX/Usability Design

**Date:** 2026-04-17
**Trigger:** Bryan's frustration that Claude produces visually memorable UIs but doesn't reason well about user perception, visual flow, click targets, or goal completion. Question: is Gemini or another model meaningfully better at UX reasoning, and is delegation worth setting up?

**Complements:** `2026-04-17-ux-evaluation-tooling.md` (covers tools and the `/ux-review` skill). This file covers the model comparison.

---

## Bottom line

**Gemini (3 Pro in particular) is meaningfully better at visual/multimodal UX critique from screenshots — and delegation is worth it, with a low-friction setup that already exists.** The gap is specific: Gemini's multimodal training lets it reason about visual layout, spacing, and CSS-level issues from a screenshot in a way Claude cannot match without tool support. The gap is *not* about deep interaction design reasoning (Fitts's Law, mental models, goal completion logic) — that's still prompt/skill territory, and Claude holds its own there.

Delegation is practical today via Gemini CLI + MCP. Setup is ~30 min.

---

## What Stitch is (and what it tells us)

Google Stitch (stitch.withgoogle.com, launched Google I/O 2025, now in Labs) is powered by Gemini 2.5 Pro for its default mode and Gemini 2.5 Flash for fast/lightweight generation. It is **not a fine-tuned UI model** — it's Gemini 2.5 with specialized system prompting + a purpose-built generation pipeline (multi-step agent, dynamic system prompts, streaming layer). The earlier "Galileo AI" foundation it replaced was also not a separate model — Stitch absorbed and replaced it.

Key Stitch capabilities:
- Text prompt → full UI (HTML/CSS, mobile-responsive)
- Sketch/screenshot → digital UI
- Iterative voice-driven refinement (March 2026 "Voice Canvas" update — Gemini interviews you about design goals and critiques in real time)
- Gemini 3 integration announced December 2025

**What this means for Bryan:** Stitch's UX quality advantage over Claude Code + "frontend-design" skill is mostly Gemini's visual reasoning, not some proprietary UI model. You don't need Stitch — you need Gemini's vision capability.

---

## Model comparison: who's better at what

### Visual layout / screenshot analysis
**Gemini 3 Pro wins clearly.** Multiple practitioner reports confirm: Gemini can analyze a screenshot, identify spacing issues, suggest specific CSS fixes, and rebuild a layout — all from visual input alone. Claude's multimodal is weaker here; without claude-in-chrome screenshots being processed, it's reasoning from code only.

On BenchLM's April 2026 multimodal scores: Gemini 3.1 Pro 90.4 vs GPT-5.4 87.9. Claude not ranked in multimodal specifically.

### Interaction design reasoning (Fitts, mental models, goal completion)
**No clear winner.** No public benchmark tests this specifically. Practitioner reports focus on visual output quality, not "did it reason about whether the user can find the button." The `/ux-review` skill we built is doing this reasoning via prompting — and it works the same regardless of which model you use, because it's a reasoning task, not a perception task.

### Code quality of generated UI
**Claude leads.** Practitioners consistently note Claude produces cleaner, more maintainable HTML/CSS/JS with better structure and zero external library sprawl. Gemini's output is visually better but often less production-ready.

### GPT-5 / o-series
**No specific UX advantage found.** GPT-5.4 is competitive on overall benchmarks (94 overall on BenchLM, tied with Gemini 3.1 Pro, Claude at 92) but no practitioner reports cite it as the go-to for UI/UX layout reasoning. No o-series UX specialization found.

### Specialized tools (v0, Uizard, Visily)
- **Vercel v0:** custom composite model (multi-step agentic pipeline), not a public LLM. Value is the pipeline + iteration loop, not a smarter base model. Used for React/Tailwind specifically.
- **Uizard / Visily:** model details not publicly disclosed. Value is curated templates + design-to-wireframe workflow, not superior UX reasoning.
- The value in these tools is workflow and template curation, not a fundamentally better underlying model.

---

## Delegation: practical setup

### Option 1: Gemini MCP server (recommended)

Multiple MCP servers exist that wrap Gemini CLI for Claude Code:
- `github.com/rlabs-inc/gemini-mcp` — MCP server for Claude Code ↔ Gemini
- `github.com/ethan-tsai-tsai/gemini-mcp-server` — wraps Gemini CLI, handles multimodal (text + image files)
- `github.com/jamubc/gemini-mcp-tool` — large file + codebase analysis angle

Setup: install Gemini CLI, add API key (Google AI Studio, ~$0.35/1M tokens for Flash, ~$3.50 for Pro), add MCP server to `.claude/settings.json`.

Typical delegation pattern for UX critique:
1. `/ux-review` runs (claude-in-chrome captures screenshots)
2. Screenshots passed to Gemini via MCP for visual critique
3. Gemini returns layout/spacing/CSS findings
4. Claude synthesizes and generates fixes

### Option 2: `/gemini` slash command (simpler, no MCP)

`paddo.dev` documents a pattern: `~/.claude/commands/gemini.md` calls Gemini CLI directly, passes clipboard images via `pngpaste`, returns critique. No MCP server needed. Routes "fix" intents to auto-apply, "analyze/review" intents to return text. **This is the lowest-friction starting point.**

### Cost / latency
- Gemini 2.5 Flash: fast (~2-3s), cheap (~$0.35/1M input tokens). Good default for UX critique loops.
- Gemini 2.5 / 3 Pro: higher quality, ~5-8s, ~$3.50/1M. For final review passes.
- No MCP server for Gemini API critique in the official MCP marketplace — community implementations only. All are thin wrappers over the Gemini CLI or API.

---

## What this means for our setup

The existing `/ux-review` skill handles interaction reasoning (Nielsen + Fitts + goal completion) well because that's a prompting/reasoning task. The gap it doesn't cover: **visual layout critique from screenshots**. That's where Gemini delegation adds real value.

**Recommended addition:** wire Gemini CLI into `/ux-review` as an optional pass — after claude-in-chrome captures screenshots, pipe them to Gemini for spatial/visual critique before Claude synthesizes the final report. The slash-command approach (no MCP needed) is the right starting point.

**Priority:** explore later. The `/ux-review` skill is new and hasn't been validated yet. Get signal on whether the interaction reasoning gap is the actual bottleneck before adding visual critique complexity.

---

## Sources

- [Google Stitch — Developers Blog announcement](https://developers.googleblog.com/stitch-a-new-way-to-design-uis/)
- [Stitch updated with Gemini 3 — Google Blog](https://blog.google/technology/google-labs/stitch-gemini-3/)
- [Hybrid AI Workflows: Spawning Gemini from Claude Code — paddo.dev](https://paddo.dev/blog/gemini-claude-code-hybrid-workflow/)
- [BenchLM — Claude vs GPT vs Gemini 2026](https://benchlm.ai/blog/posts/chatgpt-vs-claude-vs-gemini-2026)
- [Gemini 3 for UI Design — UX Planet](https://uxplanet.org/gemini-3-for-ui-design-f3fb44a295a6)
- [Gemini MCP Tool — github.com/jamubc](https://github.com/jamubc/gemini-mcp-tool)
- [Gemini MCP — github.com/rlabs-inc](https://github.com/RLabs-Inc/gemini-mcp)
- [Gemini MCP Server — github.com/ethan-tsai-tsai](https://github.com/ethan-tsai-tsai/gemini-mcp-server)
- [Gemini 3 Pro vs Claude Opus 4.5 multimodal — vertu.com](https://vertu.com/lifestyle/gemini-3-pro-vs-claude-opus-4-5-the-ultimate-multimodal-pricing-comparison/)
- [Claude vs GPT vs Gemini real coding projects 2026 — cosmicjs.com](https://www.cosmicjs.com/blog/best-ai-for-developers-claude-vs-gpt-vs-gemini-technical-comparison-2026)
