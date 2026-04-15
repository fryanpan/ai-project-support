---
name: respawn-sessions
description: Re-open all of Bryan's long-running Claude Code sessions in iTerm tabs, one per project, based on the projects marked `respawn: true` in registry.yaml. Use after a Mac reboot, after closing iTerm by accident, or any time the working set of sessions needs to be rebuilt from scratch.
---

# Respawn Sessions

Re-open Bryan's long-running Claude Code sessions in iTerm tabs.

## What it does

For each project in `registry.yaml` with `respawn: true`:
1. **Check whether a Claude Code session is already running with that project's directory as its cwd.** If yes, skip — never spawns a duplicate. Detection uses `ps` + `lsof` to read each running `claude` process's working directory.
2. Otherwise: open a new iTerm tab (or window if iTerm has none open), set the tab name to the project's `session_name`, `cd` into the project path, and run `claude --continue` to resume the most recent session in that directory.

The `claude --continue` invocation picks up Bryan's user-level zsh `claude` function from `~/.zshrc`, which adds the discord channel + claude-hive channel flags automatically. Auto permission mode is set via `defaultMode: "auto"` in `~/.claude/settings.json`, so no extra flags are needed.

## Safety: dry-run by default

The script is **dry-run by default**. A bare invocation prints what it WOULD do (which projects are already running, which would be spawned) and exits without touching iTerm. To actually spawn tabs you must pass `--execute`.

```bash
# Safe preview — doesn't spawn anything:
python3 respawn.py

# Actually spawn:
python3 respawn.py --execute

# Help:
python3 respawn.py --help
```

Manual invocations should normally be dry-run first to verify the target list, then re-run with `--execute` once the list looks right.

## How to invoke

### Manually (from a conductor session)

```bash
# Preview (recommended first):
python3 /Users/bryanchan/dev/ai-project-support/.claude/skills/respawn-sessions/respawn.py

# Actually respawn missing sessions:
python3 /Users/bryanchan/dev/ai-project-support/.claude/skills/respawn-sessions/respawn.py --execute
```

Or, if you have this skill loaded via the Skill tool, just say "respawn my sessions" — Claude will run the dry-run for you first, show you what it would spawn, and only proceed with `--execute` after you confirm.

## How to add or remove a project from the respawn list

Edit `registry.yaml` and add (or remove) two fields on the project's entry:

```yaml
projects:
  example-project:
    type: personal
    path: ~/dev/example-project
    repo: fryanpan/example-project
    respawn: true              # ← include in respawn
    session_name: "Example"    # ← iTerm tab name (optional; defaults to humanized key)
    docs:
      ...
```

`respawn: true` is required. `session_name` is optional — if missing, the script uses a Title-Cased version of the registry key.

No need to redeploy the script — the next respawn pass picks up the new registry contents automatically.

## How it parses registry.yaml

The script uses a minimal regex-based YAML parser (~30 lines) instead of PyYAML, so there are no Python package dependencies — only the system Python3 that ships with macOS. The parser handles the registry's specific structure (2-space indented project keys, 4-space indented scalar fields) and ignores everything else (nested `docs:`, `linear:`, `notion:` blocks).

## Bootstrapping requirements

For each project to actually have a session to resume:

- The project's `path` must exist as a directory
- The project must have at least one prior Claude Code conversation in that directory (so `claude --continue` finds something to resume)

For brand-new projects you've never opened in Claude Code, the first launch needs to be manual — start it once, do something, exit. After that the respawn script can pick it up.

The script logs `[skip]` for any registry entry whose `path` doesn't exist on disk and continues with the rest, so a partial install doesn't break the whole respawn.

## Failure modes and how to debug

- **iTerm doesn't open:** the script does `open -a iTerm` and waits 2 seconds. If iTerm is broken or removed, manual fix needed.
- **`claude` command not found in tab:** the new iTerm tab opens an interactive zsh shell that sources `~/.zshrc`, which defines the `claude` function. If the function is missing, the tab will print a "command not found" error. Re-add the function to `~/.zshrc`.
- **Wrong session resumed:** `claude --continue` resumes the most recent conversation in the cwd. If you accidentally started a fresh session in that cwd at any point, it's now the "most recent." Fix: open the project, run `/resume` in-session, pick the right one, exit, and the next respawn will grab it.
- **Tab name wrong:** edit `session_name` in registry.yaml.
