# MCP Servers: What People Use and Whether They're Worth It

**Date:** 2026-02-21
**Problem:** What MCP servers are people actually using with Claude Code, what workflows do they enable, and which are mature enough to adopt?

## Summary

MCP (Model Context Protocol) has become the standard way to connect Claude Code to external tools. Anthropic now maintains an official registry, Claude Code has native support (including Tool Search for lazy-loading), and the ecosystem has over 3,000 servers listed in directories. However, quality varies wildly — most servers are thin API wrappers that don't work well with LLMs, security is still immature, and the proliferation of low-quality servers creates more noise than value.

**Bottom line:** A small number of MCP servers are genuinely useful and worth adopting. Most are not. Start with 2-3 that solve real pain points, prefer official/first-party servers, and be cautious about security.

---

## The Honest Assessment

Before listing servers, the critical context:

- **Most MCP servers disappoint.** Developers treat them like REST API wrappers, but "a good REST API is not a good MCP server." LLMs need different tool interfaces than humans.
- **Security is immature.** Prompt injection via tool responses, tool poisoning, session IDs in URLs, minimal auth guidance. Treat each server like a microservice with its own blast radius.
- **Proliferation creates noise.** 3,000+ servers in directories, but quantity doesn't mean quality. Too many loaded servers degrade Claude's ability to pick the right tool.
- **The protocol is fine; the servers aren't.** MCP standardization is valuable, but the practical developer experience of building and deploying servers still has friction.

**Sources:**
- https://medium.com/@nayan.j.paul/personal-and-honest-review-of-mcp-so-far-from-a-practical-point-of-view-7e8112c8b1b5
- https://newsletter.victordibia.com/p/no-mcps-have-not-won-yet
- https://blog.sshh.io/p/everything-wrong-with-mcp
- https://ai.plainenglish.io/the-mcp-mess-and-how-to-solve-it-7a479b31fa11
- https://www.philschmid.de/mcp-best-practices

---

## Tier 1: Worth Adopting Now

These are mature, widely used, and solve real problems. First-party or officially maintained.

### GitHub MCP Server

**Problem it addresses:** Managing PRs, issues, code search, and repo operations without leaving the terminal or pasting URLs.

**What it is:** Official GitHub MCP server. HTTP transport with OAuth authentication.

**How it works:**
```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```
Then `/mcp` in Claude Code to authenticate.

**Why it matters for us:** We already use `gh` CLI extensively for cross-project PRs. The MCP server adds structured code search across repos (useful for propagation checks), PR review capabilities, and issue management — all accessible to Claude without shelling out.

**Applicability:** All managed projects. Directly supports our `/propagate` and cross-project PR workflows.

**Effort to adopt:** S — one command to add, OAuth to authenticate. Already have GitHub access.

**Source:** https://github.com/github/github-mcp-server

---

### Context7 MCP

**Problem it addresses:** Claude using outdated or hallucinated API docs. When working with libraries, Claude's training data may be months behind the current API.

**What it is:** Injects up-to-date, version-specific documentation and code examples directly into context from official library sources.

**How it works:**
```bash
claude mcp add --transport stdio context7 -- npx -y @context7/mcp@latest
```
When Claude needs library docs, it pulls the current version rather than relying on training data.

**Applicability:** Useful across all projects when working with fast-moving dependencies (React, Next.js, etc.). Less critical for our metaproject which mostly does file manipulation and git operations.

**Effort to adopt:** S — single command, no auth needed.

**Source:** https://github.com/context7/context7-mcp

---

### Sentry MCP

**Problem it addresses:** Debugging production issues requires switching to Sentry's UI, finding the right error, copying stack traces back.

**What it is:** Official Sentry MCP server. HTTP transport with OAuth.

**How it works:**
```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```
Enables queries like "What are the most common errors in the last 24 hours?" or "Show me the stack trace for error ID abc123."

**Applicability:** Any project using Sentry for error monitoring. Useful for debugging sessions where you'd otherwise be tab-switching.

**Effort to adopt:** S — if already using Sentry.

**Source:** https://mcp.sentry.dev

---

## Tier 2: Worth Exploring for Specific Use Cases

### Notion MCP

**Problem it addresses:** Reading/writing Notion pages and databases without the Notion UI.

**What it is:** Official Notion MCP. HTTP transport.

**How it works:**
```bash
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

**Applicability:** Directly relevant to us — we already interact with Notion for project documentation. Could streamline workflows where we read project context from Notion or push review findings.

**Caveat from our learnings:** We've already been bitten by `allow_deleting_content: true` archiving child pages. The MCP server likely wraps the same API, so the same risks apply. Use read operations freely, write operations carefully.

**Effort to adopt:** S — but need to understand which Notion API operations it exposes and whether it has the same destructive footguns.

**Source:** https://mcp.notion.com

---

### Linear MCP

**Problem it addresses:** Creating/updating issues, checking project status without switching to Linear UI.

**What it is:** Linear's MCP server for issue tracking operations.

**Applicability:** We use Linear for our team. Could integrate ticket creation into skills like `/new-project`.

**Effort to adopt:** S — if Linear provides an official MCP server with HTTP transport.

---

### PostgreSQL / Database MCPs

**Problem it addresses:** Querying databases with natural language instead of writing SQL manually.

**What it is:** Various servers (Bytebase dbhub, Supabase MCP, SQLite MCP) that expose database operations.

**How it works:**
```bash
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@host:5432/db"
```

**Applicability:** Only relevant for projects with databases. Not needed for the metaproject itself.

**Security note:** Always use read-only credentials. A compromised MCP server + write access = data loss.

**Effort to adopt:** S per project, but security review needed (M).

---

### Playwright MCP

**Problem it addresses:** Browser automation for testing, screenshots, and verification.

**What it is:** Puppeteer/Playwright MCP server for controlling a browser.

**Applicability:** Useful for projects with web UIs where you want Claude to verify visual changes or run integration tests.

**Effort to adopt:** M — requires browser runtime, more complex setup.

---

## Tier 3: Watch But Don't Adopt Yet

### Memory / Knowledge Graph MCPs

**Problem they address:** Persistent memory across Claude Code sessions.

**Why wait:** We already handle cross-session memory through CLAUDE.md files and learnings.md. These servers add complexity without clear benefit over our existing approach. The memory model (what to remember, how to retrieve it) is the hard part, not the storage.

---

### Brave Search / Perplexity MCPs

**Problem they address:** Web search from within Claude Code.

**Why wait:** Claude Code already has WebSearch and WebFetch tools built in. An MCP search server adds a redundant capability unless you specifically need Brave's privacy model or Perplexity's AI summaries.

---

### Figma MCP

**Problem it addresses:** Design-to-code workflows.

**Why wait:** Only relevant for projects with Figma-based design workflows. Interesting but niche. The design-to-code pipeline still requires significant manual refinement.

---

### Desktop Commander / File System MCPs

**Problem they address:** File system operations.

**Why wait:** Claude Code already has native Read, Write, Edit, Glob, Grep tools. These servers are redundant for Claude Code users (they make more sense for Claude Desktop).

---

## How to Configure MCP for Claude Code

### Key concepts

- **Three scopes:** `local` (you, this project), `project` (shared via `.mcp.json` in repo), `user` (you, all projects)
- **Three transports:** HTTP (recommended for remote), SSE (deprecated), stdio (local processes)
- **Tool Search:** Auto-enabled when MCP tools exceed 10% of context. Lazy-loads tools on demand instead of preloading all definitions. This means you can have many servers configured without context bloat.
- **OAuth support:** Use `/mcp` inside Claude Code to authenticate with servers that require it.

### Recommended setup pattern

```bash
# User scope — available in all projects
claude mcp add --transport http --scope user github https://api.githubcopilot.com/mcp/
claude mcp add --transport http --scope user sentry https://mcp.sentry.dev/mcp

# Project scope — shared with team via .mcp.json
claude mcp add --transport http --scope project notion https://mcp.notion.com/mcp

# Local scope — personal, this project only (default)
claude mcp add --transport stdio context7 -- npx -y @context7/mcp@latest
```

### Best practices

1. **Start with 2-3 servers.** Add more only when you hit a specific pain point.
2. **Prefer HTTP transport** over stdio for remote services — more robust, OAuth support.
3. **Use read-only credentials** for database servers.
4. **Check `/mcp` status** periodically — servers can silently disconnect.
5. **Don't install servers that duplicate built-in tools** (file system, search).
6. **Use Tool Search** (`ENABLE_TOOL_SEARCH=auto`) to avoid context bloat with many servers.
7. **Scope appropriately:** GitHub/Sentry as `user` (cross-project), project-specific tools as `local` or `project`.

**Source:** https://code.claude.com/docs/en/mcp

---

## Recommendations for Our Projects

### Do now

1. **Add GitHub MCP (user scope)** — we interact with GitHub on every project. The MCP server gives Claude structured access to PRs, issues, and code search without `gh` CLI parsing.
2. **Add Context7 (user scope)** — zero-cost improvement for any session where we're working with library APIs.

### Explore later

3. **Notion MCP** — test read operations first, understand what it exposes before enabling writes. Given our past `allow_deleting_content` incident, be cautious.
4. **Linear MCP** — if/when Linear ships an official MCP server with HTTP transport, integrate into `/new-project` skill.
5. **Project-scoped `.mcp.json`** — once we've validated which servers help, add a `.mcp.json` to our template so new projects get them automatically.

### Skip

6. **File system / Desktop Commander MCPs** — redundant with Claude Code's native tools.
7. **Memory MCPs** — we have CLAUDE.md and learnings.md; these add complexity without clear benefit.
8. **Search MCPs** — Claude Code already has WebSearch/WebFetch.
9. **Any MCP server with < 100 GitHub stars and no first-party backing** — the quality floor is too low.

---

## Key Takeaway

MCP is the right abstraction — a standard protocol for connecting AI to tools. But the ecosystem is in an "early web" phase where most content is low quality and security is an afterthought. The winning strategy is conservative: adopt the few high-quality first-party servers (GitHub, Sentry, Notion), ignore the long tail, and revisit in 6 months as the ecosystem matures.

For our metaproject specifically: GitHub MCP is the highest-value addition since we do cross-project PR work daily. Everything else is nice-to-have.
