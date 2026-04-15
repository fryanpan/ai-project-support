#!/usr/bin/env python3
"""
Respawn Bryan's long-running Claude Code sessions in iTerm tabs.

Reads `registry.yaml` from the parent ai-project-support repo. For each
project with `respawn: true`:
  1. Check whether a Claude Code session is already running with that
     project's directory as its cwd. If yes, skip — don't duplicate.
  2. Otherwise, open a new iTerm tab, cd into the project path, and run
     `claude --continue` to resume the most recent session in that dir.

Safety: this script is **dry-run by default**. Pass `--execute` to actually
spawn iTerm tabs. Without `--execute` it just prints what it WOULD do.

Invoked manually via the `/respawn-sessions` skill (typically after a Mac
reboot, or after closing iTerm tabs by accident). Bryan is usually at the
keyboard when the respawn happens, so the post-spawn workflow is to walk
through the new iTerm tabs and press Enter on the dev-channel popup that
fires for each session — much faster than re-opening each session by hand.

No PyYAML dependency — uses a minimal regex-based parser that handles the
registry's specific structure (2-space project keys, 4-space scalar fields).
Ignores nested blocks like `docs:`, `linear:`, `notion:` etc.
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
import time
from typing import Dict, List, Set, Tuple

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.normpath(os.path.join(SCRIPT_DIR, "..", "..", ".."))
REGISTRY_PATH = os.path.join(REPO_ROOT, "registry.yaml")
TAB_SPAWN_DELAY_SEC = 1.0
ITERM_BOOT_DELAY_SEC = 2.0
LSOF_TIMEOUT_SEC = 5.0
PS_TIMEOUT_SEC = 5.0


# --- registry.yaml parsing ---------------------------------------------------

def parse_registry(path: str) -> Dict[str, Dict[str, str]]:
    """Minimal regex-based parser for our specific registry.yaml structure.

    - 2-space indent: project key (e.g. `  ai-project-support:`)
    - 4-space indent: scalar field (e.g. `    path: ~/dev/foo`)
    - Anything more deeply nested is ignored (docs, linear, notion, etc.)
    """
    if not os.path.isfile(path):
        sys.exit(f"registry.yaml not found at {path}")

    projects: Dict[str, Dict[str, str]] = {}
    current: str | None = None

    with open(path, "r") as f:
        for raw in f:
            line = raw.rstrip("\n")
            stripped = line.strip()
            if not stripped or stripped.startswith("#"):
                continue

            # Project key: exactly 2-space indent, identifier + ":" + EOL
            m = re.match(r"^  ([a-zA-Z][a-zA-Z0-9_-]*):\s*$", line)
            if m:
                current = m.group(1)
                projects[current] = {}
                continue

            if current is None:
                continue

            # Scalar field: exactly 4-space indent, key: value
            m = re.match(r"^    ([a-z_]+):\s*(.*)$", line)
            if m:
                key = m.group(1)
                value = m.group(2).strip().strip('"').strip("'")
                if value:
                    projects[current][key] = value

    return projects


def humanize(name: str) -> str:
    return name.replace("-", " ").replace("_", " ").title()


def collect_targets() -> List[Tuple[str, str]]:
    """Return list of (session_name, expanded_path) for projects with respawn: true."""
    projects = parse_registry(REGISTRY_PATH)
    targets: List[Tuple[str, str]] = []

    for name, fields in projects.items():
        respawn = fields.get("respawn", "").lower()
        if respawn != "true":
            continue

        raw_path = fields.get("path", "")
        if not raw_path:
            print(f"[skip] {name}: no path field", file=sys.stderr)
            continue

        path = os.path.expanduser(raw_path)
        if not os.path.isdir(path):
            print(f"[skip] {name}: path missing on disk: {path}", file=sys.stderr)
            continue

        session_name = fields.get("session_name", "") or humanize(name)
        targets.append((session_name, path))

    return targets


# --- already-running session detection --------------------------------------

def get_running_claude_cwds() -> Set[str]:
    """Return the set of normalized cwd paths for all currently running
    Claude Code CLI processes on this machine.

    Filters strictly to processes whose first argv element basename is
    exactly `claude` — excludes `claude-hive`, `claude-channel`,
    `claude-respawn`, etc. Uses `lsof` to read each process's cwd via
    its file-descriptor table, which works without /proc on macOS.
    """
    cwds: Set[str] = set()

    # 1. List all processes
    try:
        ps_out = subprocess.run(
            ["ps", "-axww", "-o", "pid=,command="],
            capture_output=True,
            text=True,
            timeout=PS_TIMEOUT_SEC,
        ).stdout
    except (subprocess.TimeoutExpired, FileNotFoundError):
        print("[warn] ps failed; assuming no existing claude sessions", file=sys.stderr)
        return cwds

    # 2. Find pids whose first arg's basename is exactly "claude"
    pids: List[int] = []
    for line in ps_out.split("\n"):
        line = line.strip()
        if not line:
            continue
        m = re.match(r"^(\d+)\s+(.*)$", line)
        if not m:
            continue
        pid_str, cmd = m.group(1), m.group(2).strip()
        if not cmd:
            continue
        first_arg = cmd.split()[0]
        if os.path.basename(first_arg) == "claude":
            try:
                pids.append(int(pid_str))
            except ValueError:
                pass

    if not pids:
        return cwds

    # 3. Single lsof call for all pids — read cwd for each
    try:
        result = subprocess.run(
            [
                "lsof",
                "-a",
                "-p",
                ",".join(str(p) for p in pids),
                "-d",
                "cwd",
                "-Fpn",
            ],
            capture_output=True,
            text=True,
            timeout=LSOF_TIMEOUT_SEC,
        )
    except (subprocess.TimeoutExpired, FileNotFoundError):
        print("[warn] lsof failed; assuming no existing claude sessions", file=sys.stderr)
        return cwds

    # lsof -F output: each field on its own line, prefix indicates field type.
    # 'p<pid>' starts a record; 'n<path>' is the cwd path.
    for ln in result.stdout.split("\n"):
        if ln.startswith("n") and len(ln) > 1:
            cwd = ln[1:].strip()
            if cwd:
                try:
                    cwds.add(os.path.realpath(cwd))
                except Exception:
                    cwds.add(cwd)

    return cwds


# --- iTerm spawning ---------------------------------------------------------

def run_osascript(script: str) -> None:
    result = subprocess.run(
        ["osascript", "-e", script],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"osascript failed: {result.stderr}", file=sys.stderr)
        raise RuntimeError(result.stderr)


def ensure_iterm_running() -> None:
    subprocess.run(["open", "-a", "iTerm"], check=True)
    time.sleep(ITERM_BOOT_DELAY_SEC)


def escape_for_applescript(s: str) -> str:
    """Escape a string for use inside an AppleScript double-quoted literal."""
    return s.replace("\\", "\\\\").replace('"', '\\"')


def spawn_session(session_name: str, path: str) -> None:
    """Open a fresh iTerm tab (or window if iTerm has none) and run claude --continue in it.

    CRITICAL: this function must ALWAYS create a new session container before
    writing text. Earlier versions had a branch that wrote into iTerm's
    "current session" if a window already existed — which silently typed the
    command into whichever tab Bryan was focused on, sending it as a chat
    message to that tab's claude conversation. Never write to current session
    without first creating a new tab.
    """
    cmd = f'cd "{path}" && claude --continue'
    script = f'''
tell application "iTerm"
  activate
  if (count of windows) is 0 then
    create window with default profile
  else
    tell current window
      create tab with default profile
    end tell
  end if
  tell current window
    tell current session
      set name to "{escape_for_applescript(session_name)}"
      write text "{escape_for_applescript(cmd)}"
    end tell
  end tell
end tell
'''
    run_osascript(script)


# --- entrypoint -------------------------------------------------------------

HELP_TEXT = """\
respawn.py — Re-open Bryan's long-running Claude Code sessions in iTerm.

Usage:
  python3 respawn.py             Dry run — print what would happen, no spawning.
  python3 respawn.py --execute   Actually open iTerm tabs and start the sessions.
  python3 respawn.py --help      Show this message.

Behavior:
  - Reads ~/dev/ai-project-support/registry.yaml.
  - For each project with `respawn: true`, checks whether a Claude Code
    session is already running with that project's directory as its cwd
    (via `ps` + `lsof`).
  - Skips projects that are already running.
  - For the rest: opens a new iTerm tab, cd's into the project path, and
    runs `claude --continue`.

Safety: dry-run by default to prevent accidental duplicate spawns.
"""


def main() -> int:
    args = sys.argv[1:]

    if "--help" in args or "-h" in args:
        print(HELP_TEXT)
        return 0

    execute = "--execute" in args

    targets = collect_targets()
    if not targets:
        print("No projects with respawn: true found in registry.yaml", file=sys.stderr)
        return 1

    running_cwds = get_running_claude_cwds()

    targets_to_spawn: List[Tuple[str, str]] = []
    skipped_already_running: List[Tuple[str, str]] = []

    for name, path in targets:
        normalized = os.path.realpath(path)
        if normalized in running_cwds:
            skipped_already_running.append((name, path))
        else:
            targets_to_spawn.append((name, path))

    print(f"Registry has {len(targets)} respawn-enabled projects.")
    print(f"Detected {len(running_cwds)} running Claude Code session(s) on this machine.")

    if skipped_already_running:
        print(f"\nAlready running ({len(skipped_already_running)} — will SKIP):")
        for name, path in skipped_already_running:
            print(f"  ✓ {name:25s}  {path}")

    if targets_to_spawn:
        print(f"\nNeed to spawn ({len(targets_to_spawn)}):")
        for name, path in targets_to_spawn:
            print(f"  + {name:25s}  {path}")
    else:
        print("\nAll registry sessions are already running — nothing to spawn.")
        return 0

    if not execute:
        print(
            f"\nDRY RUN — pass --execute to actually open the {len(targets_to_spawn)} tab(s)."
        )
        return 0

    print(f"\nSpawning {len(targets_to_spawn)} session(s)...")
    ensure_iterm_running()

    for name, path in targets_to_spawn:
        try:
            spawn_session(name, path)
        except Exception as e:
            print(f"[error] {name}: {e}", file=sys.stderr)
            continue
        time.sleep(TAB_SPAWN_DELAY_SEC)

    print(f"Done. {len(targets_to_spawn)} tab(s) spawned.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
