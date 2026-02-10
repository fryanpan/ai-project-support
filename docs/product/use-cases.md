# Use Cases

## Three Project Types

### Personal Projects

Projects Bryan owns and develops directly (e.g., health-tool, bike-tool).

- **Registry entry**: Full access — local path, GitHub repo, Linear team
- **Cross-project changes**: Via GitHub PRs from metaproject
- **Reads**: From main worktree at `~/dev/{project}`
- **Skills used**: `/aggregate`, `/propagate`, `/update-project`, `/research`

### Advisory Projects

External teams Bryan helps adopt Claude Code workflows (e.g., Booster).

- **Registry entry**: May not have repo access initially. Includes team info, Notion links, engagement goals/timeline
- **Cross-project changes**: Via config bundles delivered to the team (not PRs)
- **Reads**: From team's repo once access is granted, or from Notion/docs
- **Skills used**: `/setup-team` (planned), `/research`, `/new-project` (for initial config)

### Collaborator Projects

Projects kicked off by non-technical collaborators (e.g., Joanna) who have domain expertise and ideas but aren't day-to-day programmers. Bryan helps with initial setup; Claude becomes their primary collaborator.

- **Registry entry**: Full access (Bryan sets up the repo). Includes collaborator context (domain expertise, preferences, what they're comfortable with)
- **Who they are**: Smart, creative people with domain expertise (energy, housing, policy, design, etc.) who did some programming years ago or have light technical exposure. They think in problems and solutions, not frameworks and APIs.
- **What they need from the metaproject**:
  - `/new-project` scaffolds everything so they don't have to think about repo setup, CI, tooling
  - CLAUDE.md written to orient Claude for a non-technical collaborator (explain more, suggest approaches, don't assume familiarity with dev tooling)
  - Skills tuned for their workflow — more conversational planning, more guardrails, Claude takes the lead on technical decisions
  - Lower-friction onboarding — Conductor or Claude Desktop rather than CLI
- **Ongoing support**: Bryan can use `/update-project` to push improvements, check in via `/aggregate` to see how the project is going
- **Skills used**: `/new-project`, `/update-project`, `/research`

---

## Use Case 1: Propagate a Skill Improvement

**Trigger**: Updated the retro skill template after learning that transcript JSONL analysis should be delegated to a subagent.

**Flow**:
1. Update `templates/skills/retro/SKILL.md` with the improvement
2. Run `/propagate retro` — diffs template against each project's version
3. Review diffs, noting project-specific customizations to preserve
4. Create PRs on each target repo
5. Log to `research/applied/`

---

## Use Case 2: Research and Adopt a New Tool

**Trigger**: Heard about a new Claude Code plugin or community tool.

**Flow**:
1. Run `/research <tool-name>` — searches web, fetches docs, evaluates
2. Findings stored in `research/evaluations/{date}-{tool}.md`
3. If actionable: note which projects benefit, what changes are needed
4. Run `/propagate` to push config changes (e.g., add plugin to settings.json)

---

## Use Case 3: Scaffold a New Personal Project

**Trigger**: Starting a new project from scratch.

**Flow**:
1. Run `/new-project`
2. Provide: name, description, language/stack, Linear team
3. Metaproject creates GitHub repo, Linear project, pushes scaffold (CLAUDE.md, skills, rules, settings, docs)
4. Adds project to `registry.yaml`
5. User clones and starts working

---

## Use Case 4: Aggregate Cross-Project Learnings

**Trigger**: Periodic (weekly) or after a major feature lands.

**Flow**:
1. Run `/aggregate`
2. Reads learnings and retros from all registered projects
3. New entries appended to `knowledge/cross-project-learnings.md`
4. Cross-cutting patterns identified and written to `knowledge/patterns.md`
5. Patterns may trigger template updates or `/propagate` actions

---

## Use Case 5: Advisory Team Setup (e.g., Booster)

**Trigger**: Engagement with an external team to help them adopt Claude Code.

**Flow**:
1. **Understand the team** — Review their existing tools, repos, tickets, PRs, and team structure. Each team has made their own choices:

   | Choice | Examples | Impact on Setup |
   |--------|----------|-----------------|
   | **Ticket tracking** | Linear, Jira, Asana, GitHub Issues, Notion | MCP integration, skill references to tickets |
   | **Docs** | Notion, Confluence, Google Docs, markdown in repo | MCP integration, where context lives |
   | **CI/CD** | GitHub Actions, CircleCI, GitLab CI, Vercel | Deploy skills, test commands |
   | **Repo hosting** | GitHub, GitLab, Bitbucket | MCP integration, PR workflow |
   | **Communication** | Slack, Discord, Teams | MCP integration for async updates |
   | **IDE preference** | VS Code, JetBrains, terminal | Affects onboarding path (Claude Code CLI vs extension vs Conductor) |

   Respect existing choices where reasonable. Claude Code integrates with most tools via MCP servers — the config just needs to match.

2. **Draft Claude config** tailored to their stack:
   - `CLAUDE.md` with project-specific context (architecture, conventions, data flows)
   - `.claude/skills/` — plan, implement, retro (from templates), plus any role-specific skills (e.g., PM workflow for a product manager)
   - `.claude/rules/feedback-loop.md`
   - `.claude/settings.json` with plugins matched to their stack:
     - Language-specific: `pyright-lsp`, `typescript-lsp`, etc.
     - Tool integrations: `linear`, `github`, etc.
     - Workflow: `superpowers`, `code-review`, `commit-commands`
   - MCP server config (`.mcp.json`) for their tools (ticketing, docs, repo)

3. **Merge existing team setup** — If team members have existing Claude configs (like Esau's setup for Booster), review and incorporate what works into the shared config.

4. **Bring in community plugins** — Research and evaluate relevant plugins:
   - Superpowers (software dev workflows, multiagent patterns)
   - Frontend design (for UI-heavy teams)
   - Context7 (API documentation lookup)
   - Language/framework-specific plugins

5. **Set up feedback loop** — The retro skill is the critical piece:
   - Install retro skill that analyzes transcripts automatically
   - Claude surfaces pain points, proposes actions, executes approved changes
   - Run retro on past transcripts to find patterns
   - Improvements feed back into shared config

6. **Onboard team members** — Pair with 1-2 people to demonstrate effective workflows. Show:
   - How to use plan mode for non-trivial features
   - How subagents can parallelize work
   - How the feedback loop compounds gains
   - How Conductor/Desktop provide one-click access to VS Code when needed

7. **Track progress** — Log per-feature velocity, check in against engagement goals.

---

## Use Case 6: Kick Off a Collaborator Project (e.g., Joanna's idea)

**Trigger**: A non-technical collaborator has a project idea — e.g., "I want to build a tool that helps homeowners compare solar panel financing options."

**Flow**:
1. **Conversation to understand the idea** — What problem does it solve? Who's it for? What would "done" look like? What does the collaborator care about (design? data? reach?)
2. **Bryan runs `/new-project`** — Scaffolds repo, Linear, Claude config. Picks a sensible stack based on the idea (e.g., Next.js for a web tool, Python for data analysis).
3. **Tailor the CLAUDE.md** for a non-technical collaborator:
   - Explain technical concepts when they come up
   - Suggest approaches rather than asking the collaborator to choose between frameworks
   - Claude takes the lead on technical architecture — collaborator focuses on product decisions
   - Default to showing working output (screenshots, live URLs) over code diffs
4. **Tailor skills** for their workflow:
   - `/plan` emphasizes outcomes and user experience over system design
   - `/implement` has Claude making more autonomous technical decisions, checking in on product/UX questions
   - Lower the barrier to "just try it" — deploy early and often so they can see results
5. **Set up Conductor or Claude Desktop** — not CLI. One-click to open, visual workspace.
6. **Handoff** — Walk through the first feature together, then the collaborator can continue with Claude independently.
7. **Ongoing** — Bryan periodically runs `/update-project` to push improvements to their config, `/aggregate` to see how it's going.

---

## Use Case 7: Update an Existing Project

**Trigger**: Templates have been improved and a project is behind.

**Flow**:
1. Run `/update-project health-tool`
2. Compares current setup against templates
3. Shows comparison report (missing, outdated, current, custom)
4. User approves which updates to apply
5. PR created on target repo with approved changes
