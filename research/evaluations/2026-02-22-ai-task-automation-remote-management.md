# AI Task Automation & Remote Management

**Date:** 2026-02-22
**Problem:** How can I maximize daily throughput on personal + professional tasks using AI agents, with the ability to give human feedback from anywhere (including phone), with minimal but sufficient oversight?

## Summary

The gap between "AI that runs on your desktop" and "AI you can manage from your phone" is real and unsolved in 2026. Claude Code + Conductor is the most powerful local setup but requires desktop presence. OpenHands has a web UI that's phone-accessible but is optimized for coding tasks, not personal task management. The most practical path to "Asana → AI agent" automation is a webhook integration (n8n/Zapier + Claude API), not a coding agent tool.

---

## Your Task Portfolio Analysis

Reviewed ~30 incomplete tasks across 4 Asana projects. Breakdown by AI-leverage:

### High AI leverage (AI could fully or mostly complete)
- **Research GLP-1 agonists for MCAS** → pure research, ideal for Claude
- **Build some stuff with AI** → meta; use Conductor directly
- **Migrate OneNotes to Notion** → automation + transformation task
- **2024-25 Carbon offsets** → research + comparison
- **Do 2025 taxes** → gather/organize docs, AI prep; human files
- **Book fall campsites / Pt Reyes boat-in** → research availability, draft reservations

### Medium AI leverage (AI researches, human decides)
- **Do we want to go live somewhere else for a few months in 2026?** → comparative research on costs, logistics
- **Plan something for GoGo's birthday** → idea generation + logistics
- **Write down more about what role I'd like when I'm back** → AI-facilitated interview → document
- **Finances - Setup finances like we want them** → analysis + recommendations
- **Consider Canada Maple syrup trip** → itinerary research

### Low/no AI leverage (human must do)
- All medical action items (take supplement, see doctor, try procedure)
- Relationship decisions ("Book 24h date night", "Consider how we want to give back more")
- Personal reflection tasks

**Pattern:** ~40% of your tasks could benefit meaningfully from AI. The blocker isn't capability — it's the feedback loop.

---

## Option 1: Claude Code + Conductor.build + Mobile Tools

**Conductor:** Mac-only desktop app, no mobile interface, no web UI. Confirmed from their homepage. To use from a phone, you need a separate tool.

**Mobile access to Claude Code — what actually exists in 2026:**

### A. Happy (free, open source) — strongest option
- **What:** iOS/Android/Web app that monitors your local Claude Code sessions
- **Architecture:** CLI on your Mac (`npm i -g happy-coder && happy`) + mobile app + E2E-encrypted relay server
- **Features:** Real-time session sync, voice-to-action (not just dictation), multiple parallel sessions, MIT licensed
- **Cost:** Free
- **Install:** `npm i -g happy-coder && happy`
- **Source:** https://happy.engineering
- **Rating:** This directly solves "give human feedback from anywhere"

### B. Claude Code Remote (open source) — notification-first approach
- **What:** Hooks into Claude Code's lifecycle and sends notifications + allows replies via Email, Telegram, LINE, or desktop alerts
- **How it works:** Claude completes a task → you get a Telegram message with execution trace → you reply → command injected back into Claude
- **Setup:** Clone repo, `npm install`, `npm run setup` (interactive wizard)
- **Limitations:** Requires ngrok for Telegram webhook testing; subagent notifications off by default
- **Source:** https://github.com/JessyTsui/Claude-Code-Remote
- **Rating:** Best for "get notified and unblock" pattern; less interactive than Happy

### C. SSH + Tailscale + Blink (Harper Reed's approach)
- **What:** Raw SSH from iPhone into Mac workstation via Tailscale VPN
- **Tools:** Tailscale (VPN), Blink Shell (iOS SSH client), Mosh (disconnect-resilient), TMUX (persistent sessions)
- **Effort:** M — Tailscale setup + Blink config, but very reliable once running
- **Limitation:** Requires your Mac to stay on; no friendly UI
- **Source:** https://harper.blog/2026/01/05/claude-code-is-better-on-your-phone/

**Verdict on Option 1:** Conductor + Happy is likely your best combination. Conductor manages parallel local agents; Happy gives you the mobile UI and feedback channel.

---

## Option 2: OpenHands (the user called it "OpenClaw")

**What it is:** Open-source AI software engineering agent (formerly OpenDevin), by All Hands AI. Web UI + self-hostable + cloud option. As of v1.4.0 (Feb 18, 2026), actively maintained.

**Capabilities:**
- CodeAct agent: bash, Python, web browsing, file editing
- Multi-agent support
- Docker sandbox for safe execution
- Web UI accessible from any browser (including phone)

**Real-world performance:**
- SWE-bench verified: ~53% claimed, ~26-35% user-reported (gap due to config, model version)
- Actively maintained: 1.3.0 (Feb 2), 1.4.0 (Feb 18) — biweekly releases
- Best for: well-scoped coding tasks with clear acceptance criteria
- Struggles with: open-ended research, personal task management, anything requiring external auth

**Mobile feedback:** Yes — web UI is browser-based. Not mobile-optimized but functional.

**Asana integration:** None built-in. Would require custom webhook glue.

**Use case fit for your tasks:**
- "Build some stuff with AI": good match for coding subtasks
- "Research GLP-1 agonists for MCAS": could work with browse mode
- Personal tasks (camping reservations, birthday planning): weak — not designed for this

**Verdict:** More accessible remotely than Claude Code, but optimized for software engineering. Overhead of self-hosting or paying for cloud is significant for non-coding personal tasks.

---

## Option 3: Webhook-Based Asana → AI Integration

**What it is:** The most direct answer to use case #1 (when I create a task, AI reviews and optionally takes it on). Build with n8n, Zapier, or Make.com + Claude API.

**How it works:**
1. Asana webhook fires on task creation/update
2. n8n/Zapier receives event
3. Calls Claude API with task details + context
4. Claude classifies task (AI-doable / human-needed / delegate)
5. For AI-doable tasks: creates a Claude Code workspace or calls another agent
6. Posts result back to Asana as a comment

**What this gives you:**
- True Asana integration — tasks flow automatically to AI
- Phone-friendly: you create tasks in Asana mobile, AI picks them up
- Human feedback loop: Claude comments on Asana tasks, you reply, Claude continues
- No desktop required for the delegation step

**Realistic for your tasks:**
- Research tasks: "Research GLP-1 agonists for MCAS" → Claude API returns findings → posts to Asana
- Planning tasks: "Plan something for GoGo's birthday" → Claude generates options → you reply with choice
- Action tasks that require execution: still needs Claude Code or OpenHands on a server

**Effort:** M — n8n is self-hostable or cloud, Asana webhooks are well-documented, Claude API is straightforward.

**Sources:**
- Asana webhook docs: https://developers.asana.com/docs/webhooks
- n8n Claude integration: https://n8n.io/integrations/claude/

---

## Option 4: OpenAI Codex CLI + Scheduled Tasks

**What it is:** OpenAI released Codex CLI in April 2025 — a terminal-based coding agent. Not the same as the original Codex model.

**Key facts (from training knowledge, Aug 2025):**
- Runs in terminal, similar to Claude Code
- Supports "full auto" mode for autonomous execution
- No built-in scheduled task feature as of Aug 2025
- "Codex Desktop GUI" isn't an official product — may refer to ChatGPT desktop with Codex integration

**Scheduled tasks generally:**
- No AI agent tool (Claude Code, OpenHands, Codex CLI) has native scheduled task support
- Workarounds: cron jobs that trigger agent CLI invocations
- `cron + claude -p "complete this task"` works but requires a server

**Compared to Claude Code:**
- Codex CLI: lighter weight, less capable on complex multi-step tasks in user testing
- Claude Code: deeper tooling, more capable agents, better for your use cases

**Verdict:** Weaker option for your tasks. Codex CLI is less capable than Claude Code for complex work, and scheduled tasks require custom cron infrastructure either way.

---

## Recommended Architecture for Your Use Case

Given: maximize daily throughput + feedback from anywhere + minimal oversight

### Tier 1: Quick wins (now)
1. **Use Claude Code in Conductor directly for research tasks** — "Research GLP-1 agonists for MCAS", "2024-25 carbon offsets", "Options for living somewhere else for a few months" are all Claude Code tasks you can run today
2. **Start Asana → n8n → Claude API integration** for the task-review use case (M effort, highest ROI)

### Tier 2: Next (1-2 months)
3. **Self-host OpenHands** for browser-accessible agent sessions — gives you mobile check-in without SSH
4. **Build Asana comment-based feedback loop** — Claude posts progress to tasks as comments; you reply from Asana mobile

### Tier 3: Watch
5. **Claude Code remote/headless** — Anthropic is actively developing this; may ship native remote management
6. **Conductor mobile** — if they ship a companion app or web UI, this becomes much more powerful

---

## Option 4: OpenAI Codex CLI + Scheduled Tasks (updated)

**"Codex Desktop GUI"** is not a distinct product. It refers to either:
- The Codex CLI (terminal agent, open-source, April 2025)
- The cloud-hosted Codex agent accessible through ChatGPT web (no API, no scheduling, requires manual submission)

**Scheduling: neither has native scheduling.** The CLI can be called from cron (`codex --approval-mode full-auto "task"`), but this requires your machine to be running.

**Claude background tasks (claude.ai):** Anthropic's own async task system. You submit a task via UI, Claude works on it with computer use + browsing, notifies you when done. No API access as of Feb 2026 — UI only, requires manual initiation. Most promising for fire-and-forget but not yet programmable.

**Best scheduling approaches today:**
- GitHub Actions + `claude-code-action` (officially maintained, code-focused)
- n8n self-hosted + Claude API + Asana nodes (visual, no code, M effort)
- Asana webhook → cloud function → Claude API → write back to Asana (most flexible, ~4h build)

**Verdict:** Codex CLI is weaker than Claude Code for your tasks. True "scheduled AI agent" infrastructure is still custom work. The n8n path is the most practical for Asana integration.

---

## Revised Recommended Architecture

Given your goal (max throughput + feedback from anywhere + minimal overhead):

### The stack
1. **Conductor** — run parallel agents locally on your Mac
2. **Happy** — mobile app that mirrors your Conductor sessions and lets you respond via voice or text from your phone
3. **Claude Code Remote** (optional) — add Telegram notifications for "task complete" alerts
4. **n8n + Claude API** — Asana webhook integration for the "AI reviews new tasks" use case

### Setup order
1. Install Happy (`npm i -g happy-coder && happy`) — 15 min, immediate payoff
2. Try running one of your research tasks in Conductor, monitor via Happy on phone
3. Set up Tailscale as a backup for full SSH access
4. Wire n8n → Asana webhook → Claude API (separate project, M effort)

## Key Gaps (updated after research)

1. **Feedback latency** — Happy and Claude Code Remote solve notification; voice reply is still early
2. **No AI agent tool with native task scheduler** — cron is still the workaround
3. **No Asana-native AI delegation** — webhook glue still needed
4. **Authentication on remote servers** — Claude Code OAuth requires browser redirect, hard to auth on headless machines (known issue: github.com/anthropics/claude-code/issues/22992)

The gap is narrowing fast. Happy in particular is a direct answer to "feedback from anywhere."
