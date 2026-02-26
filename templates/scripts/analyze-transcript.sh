#!/bin/bash
# analyze-transcript.sh — Deterministic transcript analysis for retro skill
# Usage: analyze-transcript.sh <path-to-jsonl>
# Output: Markdown-formatted turn-by-turn analysis with timing stats
#
# Requires: jq
#
# Hands-on time model (for parallel-session users):
#   Reading:  assistant_output_words / 150 wpm
#   Typing:   user_input_words / 60 wpm
#   Buffer:   1 min per turn (context switch overhead)
#   Meld:     consecutive turns with overlapping buffers merge into one block
#
# Filters out system-injected messages:
#   - Skill injections ("Base directory for this skill:")
#   - Local command outputs (<command-name>, <local-command-)
#   - System reminders (<system-reminder>)

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-jsonl>" >&2
  exit 1
fi

JSONL_FILE="$1"

if [ ! -f "$JSONL_FILE" ]; then
  echo "Error: File not found: $JSONL_FILE" >&2
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed. Install with: brew install jq" >&2
  exit 1
fi

# Step 1: Extract all messages into a normalized TSV format
# Columns: timestamp \t role \t is_human \t is_tool_result \t word_count \t tools_used \t has_error \t is_system \t content_preview

jq -r '
  select(.timestamp != null and .message != null) |

  .message.role as $role |
  select($role == "user" or $role == "assistant") |

  # Is this a real human message (not a tool result)?
  (if $role == "user" and (.sourceToolAssistantUUID == null) and (.toolUseResult == null)
   then true else false end) as $is_human |

  (if .sourceToolAssistantUUID != null or .toolUseResult != null
   then true else false end) as $is_tool_result |

  # Extract text content
  (if .message.content | type == "string"
   then .message.content
   elif .message.content | type == "array"
   then [.message.content[] |
     if .type == "text" then .text
     elif .type == "thinking" then ""
     elif .type == "tool_use" then ("TOOL:" + .name)
     elif .type == "tool_result" then
       (if .is_error then "ERROR:" + (.content // "" | tostring)
        else (.content // "" | tostring) end)
     else "" end
   ] | join(" ")
   else "" end) as $text |

  # Detect system-injected messages
  (if $is_human and (
    ($text | startswith("Base directory for this skill:")) or
    ($text | test("^<(command-name|local-command|system-reminder)")) or
    ($text | startswith("<local-command-caveat>"))
  ) then true else false end) as $is_system |

  # Word count (for non-system messages only; system messages get 0)
  (if $is_system then 0
   else ($text | split(" ") | map(select(length > 0)) | length) end) as $words |

  # Extract tool names (assistant only)
  (if $role == "assistant" and (.message.content | type == "array")
   then [.message.content[] | select(.type == "tool_use") | .name] | join(",")
   else "" end) as $tools |

  # Detect errors
  (if (.message.content | type == "array")
   then ([.message.content[] | select(.type == "tool_result" and .is_error == true)] | length > 0)
   elif ($text | test("(?i)error|failed|exit code [1-9]"))
   then true
   else false end) as $has_error |

  # Content preview
  # Human (non-system): full text up to 2000 chars
  # Human (system): tag as [SYSTEM] with brief preview
  # Assistant with tools: list tool names
  # Assistant text: first 150 chars
  (if $is_human and $is_system then ("[SYSTEM] " + ($text | .[:100]))
   elif $is_human then ($text | if length > 2000 then .[:2000] + " [TRUNCATED]" else . end)
   elif $role == "assistant" and ($tools | length > 0) then ("tools: " + $tools)
   elif $role == "assistant" then ($text | .[:150])
   else ($text | .[:150]) end) as $preview |

  [.timestamp, $role, ($is_human | tostring), ($is_tool_result | tostring),
   ($words | tostring), $tools, ($has_error | tostring), ($is_system | tostring), $preview] | @tsv
' "$JSONL_FILE" > /tmp/transcript_messages.tsv

# Step 2: Group into turns, filter system messages, meld, and calculate stats
awk -F'\t' '
BEGIN {
  turn = 0
  print "# Transcript Analysis"
  print ""
  print "## Turns"
  print ""
}

# Real human message starts a new turn (skip system-injected messages)
$2 == "user" && $3 == "true" && $8 == "false" {
  if (turn > 0) {
    finish_turn()
  }
  turn++
  turn_ts[turn] = $1
  turn_user_text[turn] = $9
  turn_user_words[turn] = $5 + 0
  turn_asst_words[turn] = 0
  turn_tools[turn] = ""
  turn_errors[turn] = 0
  turn_asst_preview[turn] = ""
  turn_last_ts[turn] = $1
  next
}

# System-injected user messages: attach their assistant responses to current turn
$2 == "user" && $3 == "true" && $8 == "true" {
  # Do not start a new turn, just continue
  next
}

# Assistant message or tool result in current turn
turn > 0 {
  if ($2 == "assistant") {
    turn_asst_words[turn] += $5 + 0
    if ($6 != "" && turn_tools[turn] == "") {
      turn_tools[turn] = $6
    } else if ($6 != "" && turn_tools[turn] != "") {
      turn_tools[turn] = turn_tools[turn] "," $6
    }
    if (turn_asst_preview[turn] == "" && $9 != "" && $9 !~ /^tools:/) {
      turn_asst_preview[turn] = $9
    }
  }
  if ($7 == "true") {
    turn_errors[turn]++
  }
  turn_last_ts[turn] = $1
}

function finish_turn() {
  # Deduplicate tools
  split(turn_tools[turn], tool_arr, ",")
  delete seen_tools
  deduped = ""
  for (i in tool_arr) {
    if (tool_arr[i] != "" && !(tool_arr[i] in seen_tools)) {
      seen_tools[tool_arr[i]] = 1
      if (deduped == "") deduped = tool_arr[i]
      else deduped = deduped ", " tool_arr[i]
    }
  }

  printf "### Turn %d — %s\n", turn, turn_ts[turn]
  printf "**User** (%d words):\n", turn_user_words[turn]
  printf "> %s\n\n", turn_user_text[turn]
  printf "**Assistant** (%d words)", turn_asst_words[turn]
  if (deduped != "") printf " | Tools: %s", deduped
  if (turn_errors[turn] > 0) printf " | ERRORS: %d", turn_errors[turn]
  printf "\n"
  if (turn_asst_preview[turn] != "") {
    printf "Preview: %s\n", turn_asst_preview[turn]
  }
  printf "\n"
}

function iso_to_epoch(ts) {
  # Convert ISO timestamp to minutes since epoch (approximate, for gap calculation)
  # Format: 2026-02-26T01:09:51.660Z
  # Extract hours and minutes for same-day comparison
  split(ts, parts, "T")
  split(parts[2], time_parts, ":")
  h = time_parts[1] + 0
  m = time_parts[2] + 0
  split(time_parts[3], sec_parts, ".")
  s = sec_parts[1] + 0
  return h * 60 + m + s / 60.0
}

END {
  if (turn > 0) finish_turn()

  print "---"
  print "## Timing Stats"
  print ""
  printf "Total turns: %d\n\n", turn

  # Calculate per-turn hands-on time
  total_read = 0
  total_type = 0
  total_buffer = 0
  total_handson = 0

  for (i = 1; i <= turn; i++) {
    read_min[i] = turn_asst_words[i] / 150.0
    type_min[i] = turn_user_words[i] / 60.0
    raw_min[i] = read_min[i] + type_min[i]
    # Each turn gets 1 min buffer for context switching
    buffered_min[i] = raw_min[i] + 1.0
  }

  # Meld overlapping turns:
  # If turn[n] start + buffered_min[n] >= turn[n+1] start, merge them
  # Work with minute-of-day timestamps
  meld_count = 0
  for (i = 1; i <= turn; i++) {
    meld_start[i] = i  # default: each turn is its own meld group
    meld_end[i] = i
    is_melded[i] = 0
  }

  for (i = 1; i < turn; i++) {
    if (is_melded[i]) continue
    t_start = iso_to_epoch(turn_ts[i])
    t_end = t_start + buffered_min[i]
    j = i + 1
    while (j <= turn) {
      t_next = iso_to_epoch(turn_ts[j])
      if (t_end >= t_next) {
        # Meld: extend the end
        is_melded[j] = 1
        meld_end[i] = j
        t_end = t_next + buffered_min[j]
        j++
      } else {
        break
      }
    }
  }

  # Print per-turn table
  printf "%s\n", "| Turn | Timestamp | User Words | Asst Words | Read (min) | Type (min) | Buffer | Turn Total | Melded? |"
  printf "%s\n", "|------|-----------|------------|------------|------------|------------|--------|------------|---------|"

  for (i = 1; i <= turn; i++) {
    melded_flag = ""
    if (is_melded[i]) melded_flag = "merged-up"
    if (meld_end[i] > i) melded_flag = "group-start"

    turn_total = raw_min[i] + 1.0
    total_read += read_min[i]
    total_type += type_min[i]
    total_buffer += 1.0

    printf "| %d | %s | %d | %d | %.1f | %.1f | 1.0 | %.1f | %s |\n",
      i, turn_ts[i], turn_user_words[i], turn_asst_words[i],
      read_min[i], type_min[i], turn_total, melded_flag
  }

  # Calculate melded hands-on (deduplicating overlapping buffers)
  melded_handson = 0
  for (i = 1; i <= turn; i++) {
    if (is_melded[i]) continue  # skip, counted in group start
    if (meld_end[i] > i) {
      # This is a meld group: sum raw times, but only 1 buffer for the whole group
      group_raw = 0
      for (k = i; k <= meld_end[i]; k++) {
        group_raw += raw_min[k]
      }
      melded_handson += group_raw + 1.0
    } else {
      melded_handson += raw_min[i] + 1.0
    }
  }

  total_handson = total_read + total_type + total_buffer
  printf "\n**Raw hands-on: %.1f min** (reading: %.1f + typing: %.1f + buffer: %.1f)\n",
    total_handson, total_read, total_type, total_buffer
  printf "**Melded hands-on: %.1f min** (overlapping turns merged, single buffer per group)\n",
    melded_handson
}
' /tmp/transcript_messages.tsv

# Cleanup
rm -f /tmp/transcript_messages.tsv
