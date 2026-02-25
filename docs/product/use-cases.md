# Use Cases

## Use Case 1: Start a New Project

**Trigger**: Starting a project from scratch — personal tool, team codebase, or a collaborator's idea.

**Flow**:
1. Run `/new-project`
2. Provide: name, description, language/stack, ticketing system
3. Metaproject creates GitHub repo, project tracking, pushes scaffold (CLAUDE.md, skills, rules, settings, docs)
4. Adds project to `registry.yaml`
5. User clones and starts working

---

## Use Case 2: Join and Improve an Existing Project

**Trigger**: You want to help an existing project adopt Claude Code workflows, or bring a project up to date with your latest templates.

**Flow**:
1. Add the project to `registry.yaml` with its path, repo, and tool metadata
2. Run `/propagate all <project-name>`
3. The skill reads the project's current setup — what skills, rules, settings, and docs it already has
4. Generates a comparison report showing what's missing, outdated, current, or custom to the project
5. You approve which updates to apply — customizations are preserved, not overwritten
6. A PR is created on the project's repo with the approved changes

The key principle: **acknowledge what's already there**. Every project has its own tools, processes, conventions, and repo structure. The metaproject reads all of that first, then proposes changes that build on it and adapt — not replace it wholesale.

---

## Use Case 3: Propagate a Skill Improvement

**Trigger**: Updated a template (e.g., improved the retro skill) and want to push it to all projects.

**Flow**:
1. Update the template in `templates/`
2. Run `/propagate retro` — diffs template against each project's version
3. Review diffs, noting project-specific customizations to preserve
4. Create PRs on each target repo
5. Log to `docs/process/propagation-log.md`

---

## Use Case 4: Aggregate Cross-Project Learnings

**Trigger**: Periodic (weekly) or after a major feature lands.

**Flow**:
1. Run `/aggregate`
2. Reads learnings and retros from all registered projects
3. New entries and cross-cutting patterns appended to `docs/process/aggregation-log.md` under a new dated section
5. Patterns may trigger template updates or `/propagate` actions

---

## Use Case 5: Research a Pain Point

**Trigger**: Something feels slow, broken, or harder than it should be — or you want a better outcome and aren't sure how to get there.

**Flow**:
1. Run `/research "how do I reduce setup friction for new projects?"` — starts from the problem, not a tool
2. Searches broadly across Claude Code features, community tools, blog posts, HN discussions
3. Findings stored in `research/{date}-{topic}.md`
4. If actionable: note which projects benefit, what changes are needed
5. Run `/propagate` to push improvements

---

## Target User

The target user for this repo is ultimately someone non-technical — or even an automated process run mostly by an agent. The skills are designed to be invoked conversationally ("update my projects", "start a new project called X") without requiring deep knowledge of git, Claude Code internals, or template mechanics.

A technical user gets more control (reviewing diffs, choosing what to propagate), but the system should work for someone who just wants to say "make sure all my projects have the latest setup" and let it handle the rest.
