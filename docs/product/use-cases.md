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

- **Registry entry**: Full access — Bryan has repo access and tool access during the engagement. Includes team info, Notion links, engagement goals/timeline.
- **Cross-project changes**: Via PRs on the team's repo (same as personal projects)
- **Reads**: From the team's repo (cloned locally)
- **Skills used**: `/setup-team` (planned), `/research`, `/new-project` (for initial config), `/propagate`, `/update-project`
- **Two workflows to support**:
  - **Technical** — for engineers on the team. Bryan knows this workflow well (it's what he uses). Focus on Claude Code config, skills, plugins, subagents, feedback loops.
  - **Non-technical** — for PMs, founders, advisors who aren't writing code daily. How to get them productive with Claude as a collaborator. This is less proven and needs experimentation.

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
   - `.claude/skills/` — retro, persist-plan (from templates), plus any role-specific skills (e.g., PM workflow for a product manager)
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

## Use Case 6: Non-Technical Workflow (Booster: Corrie/Ling, or Joanna)

This use case covers two overlapping scenarios:
- **Advisory**: Non-technical members of a team Bryan is helping (Corrie as PM, Ling as founder)
- **Collaborator**: Non-technical people kicking off their own projects (Joanna)

The technical workflow for engineers is well-understood (Bryan uses it daily). The non-technical workflow is **not yet proven** and needs experimentation.

### Who are the non-technical users?

| Person | Context | What they want to do with Claude |
|--------|---------|----------------------------------|
| **Corrie** (Booster PM) | Prototypes features, hands off to eng. Antigravity felt smooth. | Build prototypes, iterate on UX, hand working code to engineers |
| **Ling** (Booster founder) | Setup is hard, feels like getting 50% of value. | Oversee product direction, occasionally build things, set up team |
| **Joanna** (collaborator) | Domain expert (energy, housing, policy). Some Stanford CS 20 years ago. | Turn ideas into working tools — web apps, data analysis, prototypes |

### What we know works (for technical users)
- Plan mode → implement → retro cycle
- CLAUDE.md with architecture context
- Skills that structure the workflow
- Feedback loops that compound gains

### What we don't know (for non-technical users)
- **What's the right entry point?** Conductor? Claude Desktop? Something else?
- **How much technical context should Claude explain?** Too much is overwhelming, too little leaves them confused
- **What decisions should Claude make autonomously?** Technical architecture, framework choice, deployment — probably yes. Product/UX decisions — probably not.
- **What does "plan mode" look like for a PM?** They think in features and user stories, not chunks and interfaces
- **How do you onboard someone who isn't comfortable with git/terminal?** Conductor helps but there's still a learning curve
- **What does the feedback loop look like?** Retro skill assumes some technical context in the transcript
- **How do you handle the handoff?** PM builds prototype → engineer takes over. What does that git workflow look like?

### What to try first (experiments)

1. **Corrie on Booster** — have her try building a small feature end-to-end with Claude Code (via Conductor). Observe what's confusing, what works. This is the fastest feedback loop since she's already building things with Antigravity.

2. **Joanna on a side project** — pick one of her ideas, scaffold it with `/new-project`, walk through the first feature together. See where she gets stuck.

3. **Tailored CLAUDE.md** — write a version that:
   - Explains technical concepts when they come up
   - Has Claude suggest approaches rather than asking the user to choose between frameworks
   - Defaults to showing working output (deployed URLs, screenshots) over code diffs
   - Claude takes the lead on technical architecture; user focuses on product decisions

4. **Tailored rules** — adapt workflow-conventions for non-technical users:
   - Planning emphasizes outcomes and user experience over system design
   - Implementation has Claude making more autonomous technical decisions, checking in only on product/UX questions
   - Deploy early and often so they see results fast

5. **Document what works** — after each experiment, run `/retro` and capture what worked for non-technical users specifically. Feed findings back into templates.

---

## Use Case 7: Update an Existing Project

**Trigger**: Templates have been improved and a project is behind.

**Flow**:
1. Run `/update-project health-tool`
2. Compares current setup against templates
3. Shows comparison report (missing, outdated, current, custom)
4. User approves which updates to apply
5. PR created on target repo with approved changes
