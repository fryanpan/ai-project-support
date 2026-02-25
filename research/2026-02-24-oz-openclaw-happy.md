# Architecture Research: OpenClaw, Warp Oz, and Happy

**Date:** 2026-02-24
**Problem:** What approaches do these platforms take to (1) integrating with user services and (2) enabling collaborative/multi-user agent interaction?

---

## Executive Summary

Three platforms, three different bets:

- **OpenClaw** bets on **messaging channels as the universal interface**. Your AI agent lives where you already chat (WhatsApp, Telegram, Slack, iMessage). Service integration happens through MCP servers. Multi-agent routing lets one gateway serve multiple isolated agents with different personas, tools, and permissions.

- **Warp Oz** bets on **cloud orchestration at scale**. Run hundreds of agents in parallel in sandboxed Docker containers, triggered by events (GitHub PRs, Slack messages, schedules, API calls). The collaborative innovation is **oz-workspace**: chat rooms where humans and agents collaborate asynchronously with task boards and artifacts.

- **Happy** bets on **mobile-first remote control**. Your agents run on your machine; you monitor and steer them from your phone with push notifications, voice, and encrypted session sharing. The collaborative angle is lightweight — shared encrypted session links for pair-debugging.

---

## 1. OpenClaw

### What It Is
A local-first personal AI assistant with a central **Gateway** process that routes messages across 14+ channels (WhatsApp, Telegram, Slack, Discord, Signal, iMessage via BlueBubbles, Google Chat, Microsoft Teams, Matrix, Zalo, WebChat, macOS, iOS/Android). 145k+ GitHub stars. Node.js/TypeScript.

### Architecture
```
Channels (WhatsApp, Telegram, Slack, ...)
    → Gateway (ws://127.0.0.1:18789)
        → Agent Runtime (Pi Agent, RPC-based)
            → Tools (60+ built-in) + MCP Servers
```

The Gateway is the single control plane. It handles:
- WebSocket presence and session management
- 3-stage message pipeline: Ingestion → Processing (auth, slash commands, directives) → Delivery (block streaming, rate limiting, per-channel formatting)
- Channel plugin system (22 adapter slots per plugin, 34 bundled extensions)
- 9-layer security policy for tool access

### Service Integration Approach

**MCP as the universal connector.** OpenClaw has native MCP client support. You configure MCP servers in `openclaw.json`, and any agent can call the tools those servers expose. With 1000+ community MCP servers covering Google Drive, Slack, Gmail, calendars, databases, etc., this is the primary integration path.

**Channel plugins as service-specific adapters.** Each messaging platform (WhatsApp, Telegram, etc.) is a plugin implementing `ChannelPlugin` with 22 optional adapter slots. This normalizes messages into a common format regardless of source.

**Native nodes for hardware.** macOS/iOS/Android apps register as "nodes" exposing camera, screen recording, GPS, contacts, calendars, motion sensors as agent-accessible tools.

**Key insight:** OpenClaw doesn't build custom integrations for each service. It relies on MCP for tool-level integration and channel plugins for communication-level integration. This is a clean separation — the agent talks *through* channels and acts *on* services via MCP.

### Collaborative / Multi-User Features

**Multi-agent routing** is the core collaborative primitive. One Gateway can serve multiple isolated agents, each with:
- Own workspace (SOUL.md, AGENTS.md, USER.md)
- Own state directory, sessions, auth profiles
- Own tool permissions and sandbox settings
- Own model selection

Messages route to agents via **bindings** — rules matching on channel, accountId, peer (specific person/group), guildId (Discord), teamId (Slack). Precedence is strict: peer > guild > team > account > channel > default.

**Use cases this enables:**
- One WhatsApp number, different agents per contact (route your boss to "work-agent", family to "family-agent")
- Same Telegram bot with different tool permissions per group
- Shared channel account with per-sender agent isolation

**Agent-to-agent communication** via `sessions_list`, `sessions_history`, `sessions_send` tools — agents can read each other's sessions and send messages between themselves.

**Limitations:** "Direct chats collapse to the agent's main session key, so true isolation requires one agent per person." Multi-agent is multi-persona, not multi-user collaboration on the same task.

### Innovations

1. **Messaging-first UX** — meet users where they already are (WhatsApp, iMessage). No new app to install for end users.
2. **9-layer security policy** — granular tool control per agent, per channel, per sender. A "family" agent gets read-only; a "coding" agent gets full exec.
3. **Channel plugin architecture** — 22 adapter slots means any messaging platform can be added without changing the core.
4. **SOUL.md / AGENTS.md** — persona and capability definition is file-based and per-workspace, making agents easy to customize and version.
5. **Native node integration** — phone hardware (camera, GPS, contacts) becomes agent-accessible tools.

---

## 2. Warp Oz

### What It Is
A cloud-based orchestration platform for AI coding agents. Run, manage, and govern hundreds of agents in sandboxed Docker environments. Launched February 10, 2026. Already writing ~60% of Warp's own PRs.

### Architecture
```
Triggers (GitHub, Slack, Linear, Schedule, API, CLI, Web UI)
    → Warp Orchestrator (lifecycle management)
        → Cloud Agent (Docker container + git repos + tools)
            → Oz API (REST) / SDK (Python, TypeScript)
```

**Key components:**
- **Orchestrator:** Manages task lifecycle (created → running → completed/failed). Exposes operations through CLI, REST API, and SDKs.
- **Environments:** Docker images with git repos, startup commands, runtime settings. Shared across team.
- **Integrations:** First-party (Slack, GitHub, Linear — handle webhooks + context extraction) and custom (call the API from any event source).
- **Execution:** Warp-hosted (default) or self-hosted (enterprise, code stays internal).

### The Oz API

Three core endpoints:
- `POST /agent/run` — create agent execution with prompt + config
- `GET /agent/runs` — list/filter runs
- `GET /agent/runs/{runId}` — get run details, session links, config

Configuration via `AmbientAgentConfig`:
- `model_id` — LLM selection
- `base_prompt` — agent behavior
- `environment_id` — Docker environment
- `skill_spec` — skills as base prompts (`owner/repo:skill-name`)
- `mcp_servers` — tool enablement through MCP

Python and TypeScript SDKs with typed models, retries, and async support.

### Service Integration Approach

**First-party integrations** for core dev tools: Slack (message + channel + user identity), GitHub (PR metadata + diffs, issue context), Linear (issue tracking), CI systems (logs + job metadata). These handle webhooks and context extraction natively.

**MCP for tool expansion.** Centralized MCP config applies across all trigger sources. Agent configs can specify `mcp_servers` for additional tools.

**Custom integrations** via the API — any event source can create agent tasks by calling `POST /agent/run`. This is the escape hatch for services Oz doesn't natively support.

**Key insight:** Oz focuses on **developer workflow integrations** (GitHub, Slack, Linear, CI). It's not trying to be a general-purpose service connector like OpenClaw. The API is the extensibility layer — you build custom integrations by calling it.

### Collaborative / Multi-User Features

**oz-workspace** is the collaborative innovation. It's an open-source Next.js app (separate from the core platform) that provides:
- **Rooms** — chat channels where humans and agents collaborate
- **Agents** — configurable entities with system prompts, skills, MCP servers, and repos
- **Tasks** — Kanban board (backlog → in progress → done) managed by agents
- **Artifacts** — deliverables (PRs, plans, documents) produced by agents
- **Notifications** — alerts when agents hit milestones
- Real-time updates via SSE (Server-Sent Events)
- Agents can @mention each other

**Session sharing** — every agent run gets a shareable URL. Teammates can watch progress, review transcripts, or take over.

**Team-level environments** — when you configure a Docker environment, it's available to everyone on the team.

**Key insight:** Oz treats collaborative chat as a **coordination layer for agent work**, not as the primary interaction mode. The chat room is where you assign work, track progress, and review artifacts — the actual agent execution happens in sandboxed containers. This separation is interesting — the chat is for humans to steer, not for agents to converse.

### Innovations

1. **API-first orchestration** — everything is programmable. Build custom dashboards, integrate with internal tools, create higher-level workflows.
2. **Environment-as-config** — Docker containers with git repos as reproducible agent workspaces. No "works on my machine" problems.
3. **Trigger-based execution** — agents don't run continuously; they spin up in response to events (GitHub label, Slack message, schedule, API call).
4. **oz-agent-action** — run agents directly in GitHub Actions. Label an issue `oz-agent`, agent analyzes and attempts a fix. Comment `@oz-agent` on a PR for code review.
5. **Self-hosted option** — `oz-agent-worker` lets you run the compute on your own infrastructure while Warp handles orchestration.

---

## 3. Happy

### What It Is
An open-source mobile/web client for Claude Code and Codex. Expo (React Native) app + CLI wrapper + Fastify relay server. ~500 GitHub issues, actively maintained.

### Architecture
```
Desktop: happy CLI (wraps claude/codex)
    → Encrypted relay server (Fastify + Postgres + Socket.IO)
        → Mobile app (Expo, iOS/Android/Web)
```

**The relay model:**
1. CLI runs on your machine, starts Claude Code, watches activity
2. All messages encrypted client-side (AES-256-GCM, keys via NaCl box key exchange)
3. Relay server stores only opaque ciphertext — cannot read messages
4. Mobile app fetches and decrypts locally

**Key design choice:** The relay is a dumb pipe. It never sees plaintext. This is architecturally similar to Signal's relay model.

### Service Integration Approach

**Happy doesn't integrate with external services directly.** It's a remote control for Claude Code, which does its own tool integration. The innovation is:

- **MCP permission prompts on mobile** — when Claude Code tries to use an MCP tool, Happy intercepts the permission request and displays it on your phone. You approve/deny from mobile.
- **Custom agents synced to mobile** — all agents from `~/.claude/agents/` are available on the mobile app with autocomplete and command history.
- **Voice agent** — speech-to-text intermediary for planning conversations before execution.

**Key insight:** Happy doesn't try to be a service integration layer. It's a **human-in-the-loop remote control**. The value is that you can approve MCP tool calls, review agent output, and steer sessions from anywhere — the integrations themselves stay on the desktop where Claude Code runs.

### Collaborative / Multi-User Features

- **Shared encrypted session links** — share a session with a teammate for collaborative debugging/review
- **Multi-device parity** — both devices (desktop + mobile) can initiate conversations and send messages in the same session; no primary/secondary distinction
- **Push notifications** — heuristic-based alerts for permission requests, errors, task completion
- **Offline-first** — async messaging through encrypted relay with object storage; sessions persist regardless of connectivity

**Key insight:** Happy's "collaboration" is really about **extending a single user's reach** — you're collaborating with yourself across devices. The session sharing feature enables pair-debugging, but it's not designed for team-scale multi-user collaboration.

### Innovations

1. **Mobile-first agent steering** — push notifications when agents need input, approve/deny from your phone. This is exactly the "lightweight feedback loop" pattern.
2. **End-to-end encryption with dumb relay** — the server never sees your code. Self-hostable for full control.
3. **Device-switching** — press any key on desktop to take back control. Seamless handoff between phone and laptop.
4. **Voice-first planning** — talk through what you want before executing. Good for mobile contexts (walking, commuting).

---

## Cross-Cutting Analysis

### Q1: How Do These Platforms Handle Service Integration?

| Platform | Approach | Strengths | Limitations |
|----------|----------|-----------|-------------|
| **OpenClaw** | MCP servers + channel plugins | Broadest integration surface (1000+ MCP servers, 14+ channels). Clean separation between communication (channels) and action (MCP). | Local-first means you manage the infra. Each MCP server is another process to configure. |
| **Warp Oz** | First-party integrations (GitHub, Slack, Linear) + API for custom | Deep integration with dev workflow tools. API makes anything possible. | Focused on developer tools, not general services (no email, LinkedIn, calendar natively). |
| **Happy** | Passes through to Claude Code's MCP | Zero integration overhead — uses whatever Claude Code already has. Mobile permission approval is elegant. | No independent integration capability. Entirely dependent on the underlying CLI tool. |

**Synthesis:** For a general-purpose personal agent system that integrates with email, LinkedIn, Notion, Figma, etc.:
- **MCP is the right abstraction layer** (all three platforms use or support it)
- **OpenClaw's approach** of MCP-for-actions + channels-for-communication is the most complete model for non-dev services
- **Oz's API-first approach** is best for building custom integrations programmatically
- **Happy's mobile permission model** solves the human-approval problem elegantly

### Q2: What Makes Collaborative Chat Valuable?

| Platform | Collaboration Model | Value Proposition |
|----------|-------------------|-------------------|
| **OpenClaw** | Multi-agent routing (different agents for different people/channels) | **Personalization at scale** — each person interacting with your gateway gets a tailored agent with appropriate permissions |
| **Warp Oz** | Chat rooms with agents + humans, task boards, artifacts | **Team coordination** — agents as team members that take assignments, produce deliverables, and report progress |
| **Happy** | Shared encrypted sessions, mobile remote control | **Extended reach** — steer agents from anywhere, share sessions for pair-debugging |

**Synthesis:** Collaborative chat is valuable in three distinct ways:

1. **As a coordination layer** (Oz) — chat rooms aren't for agents to converse; they're for humans to assign work, review progress, and steer. The value is visibility and control, not conversation.

2. **As a routing layer** (OpenClaw) — different people reach different agents through the same infrastructure. The value is personalization and access control.

3. **As a remote control** (Happy) — chat is how you maintain human-in-the-loop from anywhere. The value is mobility and responsiveness.

For the "personal agent team lead" workflow described earlier, **all three models are relevant**:
- Oz's room model maps to domain-specific team leads
- OpenClaw's routing maps to different agents for different contexts
- Happy's mobile control maps to the "lightweight feedback on the go" requirement

---

## Applicability to Personal Agent Workflow

The user's desired workflow (manage many domain-specific agents, get lightweight mobile notifications, give feedback on the go) maps onto these platforms as follows:

| Requirement | Best Fit | How |
|-------------|----------|-----|
| Always-on agents | OpenClaw (local, Mac Mini) or Oz (cloud) | OpenClaw gateway on Mac Mini; or Oz cloud agents triggered by events |
| Mobile steering | Happy | Push notifications + mobile approval for agent decisions |
| Domain-specific agents | OpenClaw multi-agent routing | Each domain gets its own agent with workspace, tools, permissions |
| Service integrations | OpenClaw MCP + channel plugins | MCP servers for email, calendar, CRM; channel plugins for messaging |
| Team coordination | Oz workspace pattern | Chat rooms per domain, task boards, artifact tracking |
| Lightweight feedback | Happy push notifications | Get notified when agents need input, approve from phone |
| Scalable execution | Oz API | Spin up parallel agents for burst work |

**A hybrid approach** combining OpenClaw (always-on gateway + service integrations) with Happy (mobile remote control) and Oz patterns (room-based coordination) would cover the full workflow.

---

## Effort to Adopt

| Platform | Effort | Notes |
|----------|--------|-------|
| OpenClaw | **M** | Requires running a gateway process, configuring channels and MCP servers. Well-documented. Mac Mini-friendly. |
| Warp Oz | **S** | API key + environment setup. Cloud-hosted removes infra burden. SDK makes programmatic use easy. |
| Happy | **S** | `npm install`, scan QR code, done. Minimal setup for mobile access to existing Claude Code sessions. |
| Hybrid approach | **L** | Combining platforms requires integration work, but each piece is independently useful. |

---

## Sources

### OpenClaw
- https://github.com/openclaw/openclaw
- https://docs.openclaw.ai/concepts/multi-agent
- https://www.globalbuilders.club/blog/openclaw-architecture-visual-guide
- https://safeclaw.io/blog/openclaw-mcp

### Warp Oz
- https://www.warp.dev/blog/oz-orchestration-platform-cloud-agents
- https://www.warp.dev/oz
- https://docs.warp.dev/agent-platform
- https://docs.warp.dev/agent-platform/cloud-agents/platform
- https://docs.warp.dev/reference/api-and-sdk/api-and-sdk
- https://github.com/warpdotdev/oz-workspace
- https://github.com/warpdotdev/oz-agent-action
- https://github.com/warpdotdev/oz-agent-worker

### Happy
- https://github.com/slopus/happy
- https://happy.engineering/docs/features/
- https://happy.engineering/
