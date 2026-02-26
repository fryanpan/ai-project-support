# Scheduled and Async AI Agent Task Execution

**Date:** 2026-02-22
**Problem:** What tools exist for scheduling or queuing AI agent tasks autonomously? Specifically: OpenAI Codex CLI/Desktop, Claude background tasks, and broader ecosystem options including Asana integrations.

**Note on sources:** WebSearch and WebFetch are unavailable in this environment. This document is based on training knowledge (cutoff August 2025) for OpenAI Codex CLI (released April 2025) and Claude background tasks (released ~June 2025), supplemented by the existing research doc on AI automation frameworks. Source URLs are provided for human verification.

---

## 1. OpenAI Codex CLI

### What it is

OpenAI Codex CLI (not to be confused with the older Codex language model from 2021) is an open-source command-line agent released by OpenAI in **April 2025**. It is OpenAI's direct answer to Anthropic's Claude Code — a terminal-based coding agent that can read files, run shell commands, edit code, and execute multi-step tasks in a sandboxed environment.

**GitHub:** https://github.com/openai/codex

Key characteristics:
- Runs in the terminal; similar UX to Claude Code
- Powered by GPT-4o (and optionally o3/o4-mini for reasoning tasks)
- Three trust levels: `suggest` (read-only, proposes changes), `auto-edit` (edits files, asks before shell), `full-auto` (runs everything in a sandbox)
- Sandboxed execution via macOS Seatbelt or Docker (Linux) — no network access by default in full-auto mode
- Supports a `codex.md` or `AGENTS.md` context file (analogous to CLAUDE.md)
- Can be run headlessly: `codex --quiet --approval-mode full-auto "fix the failing tests"`
- Open-source (Apache 2.0), accepts PRs, actively maintained

**Maturity:** Released publicly April 2025, reached ~1.0 stability by mid-2025. More mature than community wrapper projects but behind Claude Code in ecosystem depth. The CLI itself is stable; the underlying model (GPT-4o vs o3) choice matters significantly for task quality.

### What "Codex Desktop GUI" is

Confusingly, "Codex" also refers to a separate OpenAI product announced around the same time: a **cloud-hosted autonomous coding agent** accessible via the ChatGPT web interface (not the CLI). This is sometimes called "Codex in ChatGPT" or the "Codex agent environment."

- Runs in OpenAI's cloud infrastructure, not on the user's machine
- User submits a task; Codex spins up a sandboxed environment, runs git operations, writes code, opens a PR
- Accessible to ChatGPT Pro/Team users; not open-source
- Similar concept to GitHub Copilot Workspace or Devin

There is no official "Codex Desktop GUI" application as a distinct named product (as of August 2025). The confusion likely comes from:
1. The ChatGPT web UI for submitting Codex tasks
2. Community discussion conflating the CLI with the cloud agent
3. OpenAI may have announced or demoed a desktop companion app that wasn't publicly released

**Assessment:** Treat "Codex Desktop GUI" as either the ChatGPT web interface for cloud Codex tasks, or as vaporware. There is no standalone desktop application.

### Scheduled tasks / async queue support

**Short answer: No native scheduling support in either Codex CLI or cloud Codex (as of August 2025).**

- The CLI is invocable from any scheduler (cron, GitHub Actions, etc.) but has no built-in scheduling primitives
- The cloud Codex agent runs tasks you submit manually through the ChatGPT interface — no API access, no scheduling
- There is no published task queue API for Codex
- OpenAI's Assistants API supports async task execution (submit → poll for result), but that is a separate product

**How people schedule Codex CLI tasks:**
- Wrap it in a cron job or GitHub Actions workflow
- Submit task descriptions via stdin piped from a file
- Use it in CI pipelines (`codex --approval-mode auto-edit "write tests for new functions"`)

**Sources to verify:**
- https://github.com/openai/codex (README, especially headless/CI section)
- https://openai.com/blog/introducing-codex (April 2025 launch post)
- https://platform.openai.com/docs/assistants (for async Assistants API, separate product)

---

## 2. Claude Background Tasks

### What it is

Anthropic announced **Claude background tasks** (also called "extended agentic tasks" or "async tasks") as part of the claude.ai product in mid-2025. This is distinct from Claude Code and from Claude's "extended thinking" feature (which is about longer reasoning chains, not scheduling).

**What background tasks are:**
- Submit a long-running task to Claude via the claude.ai web interface
- Claude works on it asynchronously — you don't need to stay in the tab
- You get notified (email or in-app) when the task completes or needs input
- Designed for tasks that take minutes to hours, not seconds

**Mechanism:**
- Claude can use computer use, web browsing, and code execution tools during background tasks
- Claude may pause and ask clarifying questions mid-task (task enters "waiting" state)
- Results are returned as a report or artifact in the conversation

**What it is NOT:**
- It is not a cron scheduler — you don't set "run every Monday at 9am"
- It is not available via API (as of August 2025) — claude.ai UI only
- It is not the same as "extended thinking" (which is a model reasoning feature, available via API)

**Maturity:** Early access / limited rollout as of August 2025. Available to Claude Pro and Team users. Not yet generally available with API access.

**Sources to verify:**
- https://www.anthropic.com/news/claude-background-tasks (if published)
- https://claude.ai (check "Long tasks" or "Background" in the UI)
- https://docs.anthropic.com/en/docs/agents (general agents documentation)

### Extended Thinking (separate feature, often confused)

"Extended thinking" (`thinking: {type: "enabled", budget_tokens: N}`) is a model API feature for Claude 3.7 Sonnet and Claude Opus 4.6 that allows the model to reason longer before answering. It is:
- Synchronous — you wait for the response
- Available via API today
- About reasoning depth, not scheduling

Not the same as background tasks.

---

## 3. Scheduling AI Agent Tasks: The Broader Ecosystem

### 3a. Cron + Claude API (Custom)

The simplest and most reliable pattern. Run Claude headlessly on a schedule.

**How it works:**
- Write a script that calls the Anthropic API with a prompt
- Schedule it with cron, systemd timers, GitHub Actions, or any scheduler
- Claude returns a response; your script handles output (write to file, post to Slack, open PR)

**Example pattern:**
```bash
# cron: 0 9 * * 1  (every Monday at 9am)
python scripts/weekly_review.py  # calls Claude API, posts summary to Slack
```

**Maturity:** Production-ready. This is just the Anthropic API with a wrapper.

**Limitations:**
- Stateless — each run is a fresh context unless you manage memory explicitly
- No built-in retry/backoff (must implement)
- Cost scales with frequency and token count

---

### 3b. GitHub Actions + Claude Code

A well-documented pattern for CI/CD-triggered AI agent tasks.

**How it works:**
- GitHub Action triggers on PR creation, issue comment, or schedule
- Uses `anthropics/claude-code-action@v1` (or similar) to run Claude Code in CI
- Claude reads the repo, makes changes, commits, optionally opens a PR

**Official support:** Anthropic ships `claude-code-action` as an official GitHub Action. Documented at https://github.com/anthropics/claude-code-action

**Real patterns in production:**
- Auto-fix failing tests when a PR is opened
- Auto-generate release notes on tag push
- Run code review on every PR and post inline comments
- Scheduled "code health" runs that open PRs for tech debt

**Maturity:** Production-ready. The GitHub Action is officially maintained. Used in production by teams at mid-sized companies.

**Limitations:**
- GitHub Actions minutes cost money at scale
- Claude Code in CI can be slow (minutes per run)
- Needs secrets management for the API key
- Context window limits still apply — can't read arbitrarily large repos

**Sources:**
- https://github.com/anthropics/claude-code-action
- https://docs.anthropic.com/en/docs/claude-code/github-actions

---

### 3c. n8n + Claude

**What it is:** n8n is a self-hostable workflow automation tool (like Zapier but open-source). It has a Claude node for calling the Anthropic API as part of workflows.

**Relevant capabilities:**
- Trigger workflows on schedule (cron), webhook, email, database event, etc.
- Claude node: send a prompt, get a response, use it in subsequent steps
- Can be chained: fetch data → summarize with Claude → post to Slack → create Notion page
- Supports long-running tasks via async execution modes
- Self-hostable (data stays on your infrastructure) or n8n Cloud

**Scheduling support:** Yes, first-class. n8n's scheduler node supports cron expressions with a UI editor.

**Asana integration:** n8n has both a Claude node and an Asana node. You can build:
- "When a task is created in Asana project X → pass it to Claude → update the task with AI-generated subtasks/notes"
- "Every morning → fetch Asana tasks due this week → generate a prioritized summary → post to Slack"

**Maturity:** n8n is production-ready (4+ years old, 40k+ GitHub stars). The Claude integration is newer (2024-2025) but the underlying API call pattern is stable. The weakness is workflow maintenance — n8n workflows can become brittle and hard to debug as they grow.

**Limitations:**
- Claude in n8n is just an API call — no tool use, no agentic loop
- Complex reasoning chains require multiple nodes/workarounds
- No persistent Claude memory between workflow runs unless you implement it

**Sources:**
- https://n8n.io/integrations/anthropic/ (Claude integration)
- https://n8n.io/integrations/asana/ (Asana integration)
- https://docs.n8n.io

---

### 3d. Zapier + Claude

**What it is:** Zapier is the mainstream (non-technical) workflow automation platform. Has a Claude integration via "Zapier Actions for Claude" and a direct Anthropic Claude app.

**Relevant capabilities:**
- Trigger on Asana task creation, Gmail, Slack, calendar, etc.
- Call Claude with a prompt built from trigger data
- Use Claude's response in downstream steps (update Asana, send email, etc.)

**Scheduling support:** Yes — Zapier Schedules trigger workflows at fixed intervals (hourly, daily, weekly).

**Asana → Claude pattern:**
- Trigger: New task created in Asana project
- Step: Claude analyzes task title/description, suggests priority, estimates effort, tags relevant team members
- Step: Update Asana task with Claude's output

**Maturity:** Zapier's Claude integration is stable as a basic API wrapper. Not suitable for complex agentic work — it's one prompt in, one response out. No tool use.

**Limitations:**
- Zapier is expensive at scale ($50-500+/month depending on task volume)
- No multi-turn reasoning; Claude is a single-step transform, not an agent
- Data leaves your infrastructure (relevant for sensitive codebases)

**Sources:**
- https://zapier.com/apps/claude-ai/integrations
- https://zapier.com/apps/asana/integrations/claude-ai

---

### 3e. Make.com (formerly Integromat) + Claude

Similar to Zapier but with a visual flow editor and often cheaper. Has an HTTP module that can call the Anthropic API directly, plus community-built Claude modules.

**Scheduling:** Yes, built-in scheduler.
**Asana:** Yes, native Asana module.
**Maturity:** The Claude integration is via generic HTTP call or community modules — less polished than n8n's first-party Claude node.

---

### 3f. Temporal + Claude API (Engineering-grade)

**What it is:** Temporal is a durable workflow execution platform used by Stripe, Netflix, etc. It handles retries, backoffs, state persistence, and long-running workflows natively.

**Pattern:**
- Define a Temporal workflow that calls the Claude API
- Schedule workflows via Temporal Schedules (cron-like)
- Workflow state is persisted — if Claude's API call fails, Temporal retries automatically
- Can fan out to parallel Claude calls and aggregate results

**Maturity:** Temporal itself is production-grade. The Claude integration is hand-rolled (just API calls in workflow steps). This is the right approach for teams that need reliability guarantees.

**Who this is for:** Engineering teams with existing Temporal infrastructure, or teams building AI products where task reliability matters (e.g., "this weekly report must run, every time, with audit trail").

**Sources:**
- https://temporal.io
- https://docs.temporal.io/develop/python/schedules

---

### 3g. LangGraph / LangChain Scheduled Agents

**What it is:** LangChain's LangGraph is a framework for building stateful, multi-step AI agent workflows. Can be deployed on LangSmith (LangChain's cloud platform) with scheduling.

**Relevant:**
- Supports Claude via the Anthropic integration
- Stateful — can maintain memory across steps and runs
- LangSmith Platform (cloud hosting) supports scheduled graph execution
- More powerful than n8n/Zapier for complex reasoning chains — supports branching, loops, tool use

**Maturity:** LangChain is mature (2+ years, 90k+ GitHub stars) but has a reputation for over-engineering simple problems. LangGraph (the stateful subproject) is newer and more targeted. The scheduling support in LangSmith is newer still.

**Limitations:**
- Significant learning curve for LangGraph
- LangChain has high abstraction overhead — simple things become verbose
- Cost: LangSmith has a free tier but scheduling/deployment features require paid plans

**Sources:**
- https://python.langchain.com/docs/integrations/chat/anthropic/
- https://langchain-ai.github.io/langgraph/
- https://docs.smith.langchain.com

---

### 3h. IronClaw (nearai/ironclaw)

**What it is:** A Rust reimplementation of OpenClaw focused on privacy, local-first design, and native scheduling. Built by NEAR AI. Describes itself as "your secure personal AI assistant, always on your side."

**GitHub:** https://github.com/nearai/ironclaw

Key characteristics:
- Native **Routines** — cron schedules, event triggers, and webhook handlers for background automation
- **Heartbeat System** — proactive background execution for monitoring and maintenance
- **WASM Sandbox** — untrusted tools run in isolated WebAssembly containers with capability-based permissions
- **MCP Protocol** — connects to Model Context Protocol servers for additional capabilities
- **Dynamic Tool Building** — describe a tool, IronClaw builds it as a WASM plugin without restart
- **Persistent memory** — hybrid full-text + vector search (pgvector) with workspace filesystem
- Multi-channel: REPL, HTTP webhooks, Telegram/Slack via WASM channels, web gateway with SSE/WebSocket
- Docker Sandbox for isolated container execution with per-job tokens

**Scheduling support:** Yes, first-class via Routines. Supports cron expressions, event-driven triggers, and webhook handlers — the only open-source tool in this doc with native scheduling *and* full agentic tool use.

**Privacy / security stance:** Strongest in this survey. Local-first storage (encrypted), credential injection at host boundary with leak detection, endpoint allowlisting, prompt injection defenses. No telemetry.

**Setup requirements:** Rust 1.85+, PostgreSQL 15+ with pgvector extension, NEAR AI account (authentication). More complex than GitHub Actions or n8n.

**Maturity:** Very early — created 2026-02-03, reached v0.11.1 by 2026-02-23 (3 weeks). Velocity is high (multiple releases per day during initial development). 3,100+ stars. APIs and config format will change.

**Limitations:**
- NEAR AI account required for auth — potential vendor dependency
- PostgreSQL + pgvector is a non-trivial self-hosting requirement
- Too new to have production case studies
- Rust build from source required for full customization

**Sources:**
- https://github.com/nearai/ironclaw
- https://t.me/ironclawAI (Telegram community)
- https://www.reddit.com/r/ironclawAI/

---

## 4. Asana → AI Agent Integrations

### Current state

As of August 2025, there is **no native Asana feature** that auto-assigns tasks to an AI agent when created. The integrations that exist are:

**1. Asana Rules + Webhooks**
- Asana's built-in Rules engine can trigger on task creation/modification
- Rules can call a webhook (HTTP POST to a URL you control)
- Your server receives the webhook → calls Claude API → updates the task via Asana API
- Maturity: Production-ready. Asana webhooks are stable and well-documented.
- This is the most reliable custom integration path.

**2. n8n / Zapier / Make.com (as described above)**
- Trigger: New Asana task → Claude prompt → Update Asana task
- Easiest to set up without custom code
- Limitation: Claude is a single-shot API call, not an agent that can take actions

**3. Asana AI Features (native)**
- Asana has been adding its own AI features ("AI Studio", "AI teammates") as of 2024-2025
- These are Asana's own AI, not Claude-powered
- Features include: auto-generating task descriptions, suggesting assignees, summarizing projects
- Not configurable to use Claude
- Maturity: Early access; limited to Enterprise/Business tiers

**4. Custom Integration Pattern (most capable)**
For teams that want "task created in Asana → Claude Code agent runs → PR is opened":

```
Asana Webhook → Lambda/Cloud Function → Queue (SQS/Redis) → Worker → Claude API (with tools) → GitHub PR → Asana task update
```

This requires engineering work but gives full agentic capability (Claude with tool use, not just text generation).

**Sources:**
- https://developers.asana.com/docs/webhooks-overview
- https://asana.com/product/ai (Asana's own AI features)
- https://n8n.io/integrations/asana/

---

## 5. Summary Assessment

| Tool | Scheduling | Async/Queue | Asana Integration | Agentic (tool use) | Maturity |
|------|-----------|-------------|-------------------|--------------------|----------|
| OpenAI Codex CLI | Via cron/CI only | No | No | Yes (sandboxed) | Stable (CLI) |
| OpenAI Codex Cloud | No | No | No | Yes (cloud) | Limited access |
| Claude background tasks | No (manual submit) | Yes (async return) | No | Yes | Early access |
| Claude API + cron | Via any scheduler | Build yourself | Via Asana API | Yes (with tools) | Production-ready |
| GitHub Actions + Claude Code | Yes (schedule trigger) | No | No | Yes | Production-ready |
| n8n + Claude | Yes (native scheduler) | No | Yes | No (API call only) | Stable |
| Zapier + Claude | Yes (schedule trigger) | No | Yes | No | Stable |
| Make.com + Claude | Yes | No | Yes | No | Stable |
| Temporal + Claude API | Yes (durable) | Yes (durable) | Via custom code | Yes (via API) | Production-ready |
| LangGraph + LangSmith | Yes (beta) | Yes | Via custom code | Yes | Beta |
| IronClaw | Yes (native Routines) | Yes (Heartbeat) | Via custom code | Yes (WASM + MCP) | Early (v0.11) |
| Asana AI Studio | Via Asana rules | No | Native | No (not Claude) | Early access |

---

## Recommendations for This Project

### Immediate / Low effort

1. **GitHub Actions + Claude Code** for code-related automation (PR review, propagation checks). The `claude-code-action` is officially maintained and ready to use. Relevant for running `/propagate` on a schedule.

2. **Asana Webhook → Claude API** for Asana task enrichment. If the team wants "new task arrives → Claude analyzes and suggests priority/subtasks," the path is: Asana webhook → small cloud function → Claude API → update task via Asana API. ~2-4 hours engineering work.

3. **n8n self-hosted** if the team wants a visual workflow editor without coding everything. The Claude + Asana node combination covers the stated use case.

### Requires more setup

4. **Claude background tasks** — worth monitoring as it matures. When it becomes API-accessible, it enables "fire and forget" agent tasks without managing infrastructure. Currently UI-only.

5. **Temporal** — if reliability and auditability are requirements (audit trail of every AI task run, guaranteed retries), this is the right long-term platform. Overkill for current scale.

### Watch / Wait

6. **IronClaw** — first open-source tool combining native scheduling + full agentic tool use + privacy-first design. Too new (3 weeks) for production use, but architecture is sound and velocity is high. Revisit at v1.0.
7. **Codex CLI scheduling** — OpenAI will likely add scheduling to their cloud Codex agent eventually. Not available yet.
8. **Asana AI Studio with third-party models** — Asana could open their AI Studio to external models. Not available yet.

### Skip

8. **Zapier + Claude** for agentic work — too expensive, too limited (single-shot API call, no tool use).
9. **LangGraph** unless you're building a product — high complexity for marginal gain over direct API use.

---

## Key Takeaway

The honest answer is that **true "scheduled autonomous AI agent" infrastructure is not yet off-the-shelf**. The closest thing is:
- GitHub Actions + Claude Code (code-focused, CI-triggered)
- n8n + Claude API (data-pipeline-style, scheduled)
- Custom: webhook → queue → Claude API with tools → output action

The "AI agent that wakes up on a schedule, does meaningful agentic work, and reports back" pattern requires either custom engineering or waiting for Claude background tasks to expose an API. Claude background tasks is the most promising native solution, but it's UI-only today.

For Asana specifically: Asana webhooks are the reliable integration point. Pair with a lightweight cloud function and the Claude API to get task enrichment automation today.
