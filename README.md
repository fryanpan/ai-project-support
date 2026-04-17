# AI Project Support

# Goal

Use agents to move faster across many projects at once.

Do this by having a skeleton that lets us experiment with workflows that are not yet mainstream.

But we try to keep things simple by using the latest and greatest from Anthropic and from the community ecosystem (e.g. plugins, channels, etc.) as building blocks.

Every 2–3 weeks, I might feel pain points and make some more tools that are a month or two ahead of where Claude is generally at. But a few weeks later, I assume that if any of these features are generally useful, Claude will have them in research preview. And soon after that they'll be ready for Claude Code users, and not too long after that for Cowork users.

# 2026-04-13 Iteration

## Typical Workflow This Week
1. Weekly review and goal setting
  1. At start of week, take 15 minutes to review last week's goals and progress
  2. Set this week's goals and outcomes across 8+ projects
  3. Team lead kicks off work across the team (and also plans and prioritizes manual tasks for Bryan)
2. Daily execution + improvement
  1. Agent team works in parallel
  2. Bryan works on top priority manual tasks and responds to agents individually when they need help
  3. Bryan works with team lead multiple times a day to review where team's at and unblock and update team process

## What's Different
This is how the tools here go beyond what's broadly available:

- **Team Lead Helps Improve Team Throughout Day**
  - The team lead has tools to retrospect across projects, identify issues, and deploy improvements across the whole team. I use this at least once a day!
  - We have transcript review tools that understand agent-time, hands-on time, and cost — and act on the insights
  - The team lead is a full-blown Opus Claude Code session with access across all project repos. It has the context and power to provide oversight and unblock team members
  - This is more like OpenClaw's root agent — it's more powerful than Claude Dispatch, and has patterns inspired by Sonjaya's meta-project <!-- TODO: add Sonjaya link -->

- **Reduce Overhead with Richer Event Handling**
  - Saves me 30+ minutes a day of responding to events myself and pinging agents, plus I can avoid context switching
  - Agents can talk to each other, so I can ask them to share context and figure it out instead of having to context switch and pay attention myself
  - Agents can respond flexibly to GitHub (e.g. CI, comments, merge failures, deploy failures) and Notion events (e.g. someone commented), so I don't have to
  - This builds on top of [Claude Channels](https://code.claude.com/docs/en/channels) and [claude-hive](https://github.com/KevinLyxz/claude-hive-mcp)

- **Speed Up Value Delivery with E2E Automation**
  - Software agents typically deliver features in 5–20 minutes, without need for manual review unless it's a high risk + complexity task
  - Refactoring is dramatically easier, so we can give architectural and cleanup guidance once every few days instead of needing constant human review
  - Various tools cover pieces of this flow (e.g. Claude PR Agent, Claude Automerge in Desktop)

**What Exists Now**
In early March, we built out a more custom agent framework ([product-engineer](https://github.com/fryanpan/product-engineer)) to go after these goals, but Claude has caught up! And as of this week, we've moved back to extending this lighter-weight repo. It was fun, but also too much overhead to run our own agents on Cloudflare.

In the last month, these Claude improvements have helped make the agent framework obsolete:

- **Get work done from anywhere (and with multi-user chat when useful)**
  - Claude Discord connection (like OpenClaw)
  - Claude Remote (can access Claude Code CLI on our Mac Mini from phones and laptops anywhere)
  - Allows work to continue on our home Mac Mini
  - We can quickly ask for things on the go, and also unblock agents with a minute of review to keep them moving

- **Spin up teams that manage themselves**
  - When there are enough relatively independent, complex tasks or projects, teams can get things done faster than a single serial agent (and burn credits faster :)
    - See [You Probably Don't Need Claude Agent Teams](https://www.builder.io/blog/claude-agent-teams-explained-what-it-is-and-how-to-actually-use-it) for good guidelines on when they're worth it
  - Claude's [Agent Teams](https://code.claude.com/docs/en/agent-teams) and Claude Dispatch both enable new ways of working between agents
  - But both don't yet offer the full power + customizability of Claude Code for both the team lead and subagents

## Getting Started

1. **Clone** and set up your registry:
```bash
   git clone git@github.com:your-username/ai-project-support.git ~/dev/ai-project-support
   cp registry.yaml.example registry.yaml
   # Edit registry.yaml with your projects
```

2. **Start or import a project:**
  - For a brand-new project, run `/new-project` to scaffold it from scratch and register it in your `registry.yaml`.
  - For an existing repo, run `/add-project` to register it. This adds it to the registry and propagates the shared skills, rules, and settings.

3. **Propagate templates** to your projects with `/propagate` to give them shared skills, rules, and settings.

## Skills

| Skill | Purpose |
| --- | --- |
| `/conductor` | Check in with peers, route questions, relay instructions |
| `/respawn-sessions` | Bring back all project sessions after a reboot |
| `/spawn-session` | Open a single new session |
| `/propagate` | Push improvements to all projects via PRs |
| `/aggregate` | Pull learnings into a central knowledge base |
| `/new-project` | Scaffold a new project from scratch |
| `/add-project` | Register an existing repo |
| `/ship-it` | Code review → PR → CI → merge |
| `/ticket-agent` | Autonomous ticket work in a peer session |
| `/retro` | Transcript analysis and retrospectives |
| `/research` | Investigate tools and techniques |
| `/persist-plan` | Save plans to docs |

## Private Files

`registry.yaml` and some process docs are gitignored because they contain project-specific data. See `registry.yaml.example` for the schema. After creating a worktree, run `./scripts/setup-private.sh` to symlink private files from the main worktree.

## License

[MIT](LICENSE)
