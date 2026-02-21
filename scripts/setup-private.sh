#!/bin/bash
# Symlink private files from the main worktree into a new worktree.
# Run this after creating a worktree so it has access to gitignored files.
#
# Usage: ./scripts/setup-private.sh

set -e

MAIN_WORKTREE="$HOME/dev/project-support"

if [ ! -d "$MAIN_WORKTREE" ]; then
  echo "Error: Main worktree not found at $MAIN_WORKTREE"
  echo "Update MAIN_WORKTREE in this script to match your setup."
  exit 1
fi

# Registry (project list, team metadata, IDs)
ln -sf "$MAIN_WORKTREE/registry.yaml" ./registry.yaml

# Retrospectives (auto-generated project-specific content)
ln -sf "$MAIN_WORKTREE/docs/process/retrospective.md" ./docs/process/retrospective.md

# Applied research logs (propagation records with specific PR URLs)
ln -sfn "$MAIN_WORKTREE/research/applied" ./research/applied

echo "Private files linked from $MAIN_WORKTREE"
