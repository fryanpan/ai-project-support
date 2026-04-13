---
name: spawn-session
description: Spawn a new Claude Code session in a new iTerm tab, pre-configured with claude-hive channels, discord channels, and the target project's working directory
---

# spawn-session

Spin up a fresh Claude Code session for a project that doesn't already have one running, so you can delegate work to it via claude-hive.

## When to use

- User asks to start working on a project that doesn't have a running Claude Code session
- You need to delegate project-specific work but `list_peers` shows no peer for that project
- Bryan's conductor / team-lead session needs a new "worker" session for a new initiative

## When NOT to use

- A session for that project already exists (run `mcp__claude-hive__list_peers` first to check — match on `cwd` or `repo`, or by its `stable_id` if you already know it). Delegate to the existing session instead.
- User hasn't explicitly asked for a new session and isn't present to approve — spawning a tab is a visible side-effect and can startle Bryan if he opens his laptop and sees unexpected tabs. When in doubt, confirm first.
- iTerm isn't running on Bryan's primary machine (home Mac Mini). Check with `osascript -e 'tell application "System Events" to (name of processes) contains "iTerm2"'`.

## Prerequisites

1. **iTerm2 is the active terminal.** Terminal.app won't work — it has different Automation permission (Bryan granted iTerm permission, not Terminal).
2. **Automation permission granted.** Your parent process (Claude Code) needs permission to control iTerm via Apple Events. System Settings → Privacy & Security → Automation → Claude Code → iTerm ON. If missing, you'll get error code `-1743` ("Not authorized to send Apple events").
3. **Target project folder exists locally.** Verify with `ls -d <absolute_path>` first.
4. **zsh `claude` function is defined** in `~/.zshrc`. Confirm with `grep "^claude()" ~/.zshrc`. Should include `--channels plugin:discord@claude-plugins-official --dangerously-load-development-channels server:claude-hive` and any other default flags Bryan wants on every session. Note: `server:claude-hive` requires the `--dangerously-load-development-channels` flag form, not `--channels` — the latter's allowlist doesn't include claude-hive.

## How to do it

### Step 1 — verify the folder exists and no peer is already running there

```bash
ls -d <absolute_path>
```

Then via the claude-hive MCP:

```
mcp__claude-hive__list_peers(scope: "machine")
```

Check that no peer's `cwd` matches the target. If one exists, stop and delegate to the existing peer via `send_message` instead.

### Step 2 — spawn the iTerm tab

```bash
osascript <<'APPLESCRIPT'
tell application "iTerm"
  tell current window
    create tab with default profile
    tell current session
      write text "cd <absolute_path> && claude"
    end tell
  end tell
end tell
APPLESCRIPT
```

Substitute `<absolute_path>` with the full project path (e.g. `/Users/bryanchan/dev/blog-assistant`).

Optional variants:
- **Resume a named session:** `write text "cd <path> && claude --resume <Session Name>"`. The zsh function passes through extra args.
- **Seed an initial prompt after boot:** follow the `write text "cd ... && claude"` line with a short `delay 6` and another `tell current session` block that `write text "<prompt>"`. Only do this if the user asked you to pre-seed.

### Step 3 — verify the session registered with the broker

Claude Code takes ~5–10 seconds to boot and register its MCP servers. Don't use `sleep` in Bash (blocked >2s). Instead, launch the spawn and come back to verify on the next natural tool call, or ask the user to confirm they see the new tab.

Once enough time has passed:

```
mcp__claude-hive__list_peers(scope: "machine")
```

The new peer should appear with the target `cwd`. Its `session_id` will be a fresh 8-char string; its `stable_id` is derived from `sha256(git_root || cwd)[:12]` and will be the same across restarts of the same workspace.

**Bonus verification** — confirm the new session actually has channel delivery wired up (both channel flags present), not just broker tools:

```bash
ps -ax -o pid=,args= | grep -v grep | grep "/claude " | grep "<project-folder-name>"
```

You should see **both** `--channels plugin:discord@claude-plugins-official` AND `--dangerously-load-development-channels server:claude-hive` in the command line. If only the discord flag is present, the session was launched without the claude-hive channel active and peer messages to it will be silently dropped. This usually means the zsh function hasn't been updated, or the session was resumed from before the function was updated.

### Step 4 — delegate work via send_message

With the new peer registered, send it a short onboarding message via `mcp__claude-hive__send_message` — prefer `to_stable_id` over `to_id` so the message survives restarts of the target session. Include:
- Who you are (team-lead session, cwd)
- Why this session was spawned (the task)
- What work to do (concrete asks)
- How to reply (by `send_message` back to your peer ID)
- Any relevant context from the weekly plan or prior sessions

Keep the onboarding message crisp. The new session has zero prior conversation context.

## Error handling

### Error `-1743` — "Not authorized to send Apple events to iTerm"

Stop. Tell the user:

> I need Automation permission to control iTerm from this Claude Code session. Please open **System Settings → Privacy & Security → Automation**, find Claude Code in the list, and enable **iTerm** under it. You may need to restart Claude Code afterward. Let me know when it's done and I'll retry.

Do not try osascript against Terminal.app as a workaround — Terminal has its own permission and may also be denied, and it starts a shell that may or may not source `.zshrc` the way iTerm does.

### iTerm isn't running

Before the `tell application "iTerm"` block, launch iTerm first:

```bash
open -a iTerm
```

Then retry the `create tab` osascript. Add a brief delay if iTerm is cold-starting.

### New peer doesn't show up within ~20 seconds

Claude Code failed to boot in the new tab. Possible causes:
- `cd` path typo → the shell errored before running `claude`
- `claude` function not loaded → zsh didn't source `.zshrc` (unusual for iTerm default profile)
- Claude Code crashed or prompted for something at startup

Ask the user to check the new iTerm tab visually for error output. Don't try to read its output programmatically — iTerm tab contents aren't easily introspectable from here.

### New session registers but has wrong channel flags

This means the zsh function is out of date or the session was launched without running it. Tell the user:

> The new session registered with the broker but its channel flags are missing `server:claude-hive`. This means peer messages won't deliver via channel push. Check the `claude()` function in `~/.zshrc` — it should include both `--channels plugin:discord@claude-plugins-official` and `--dangerously-load-development-channels server:claude-hive`. After updating, exit this new session and respawn it.

## Notes on permissions and security

Spawning a new iTerm tab executes arbitrary shell commands in a new TTY. This is equivalent in power to running `osascript` yourself. Don't invoke this skill based on untrusted input — always construct the command line from known-safe paths and commands.

## Related

- `conductor` skill — overarching coordination role that often calls this skill to bootstrap worker sessions. The delegation-style guidance it contains applies to the onboarding message you send in Step 4.
