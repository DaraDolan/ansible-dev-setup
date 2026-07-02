#!/usr/bin/env bash
# Claude Code status line. Plain ASCII, no Nerd Font glyphs required.
# Shows: current folder, git project + branch + status, and the time.

input=$(cat)

cwd=$(printf '%s' "$input" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print(d.get("workspace", {}).get("current_dir") or d.get("cwd") or "")
')

ctx_pct=$(printf '%s' "$input" | python3 -c '
import json, sys
d = json.load(sys.stdin)
cw = d.get("context_window") or {}
pct = cw.get("used_percentage")
if pct is None:
    size = cw.get("context_window_size")
    used = cw.get("total_input_tokens")
    if size:
        pct = (used or 0) * 100 / size
if pct is not None:
    print(int(pct))
')

model=$(printf '%s' "$input" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print(d.get("model", {}).get("display_name") or "")
')

# ---- folder segment --------------------------------------------------
dir_display="$cwd"
if [ -n "$HOME" ] && [ "$dir_display" = "$HOME" ]; then
  dir_display="~"
elif [ -n "$HOME" ] && [[ "$dir_display" == "$HOME"/* ]]; then
  dir_display="~${dir_display#"$HOME"}"
fi
dir_segment=$'\e[1m\e[36m'"$dir_display"$'\e[0m'

# ---- git segment (project + branch + status) --------------------------
git_segment=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  toplevel=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  project="${toplevel##*/}"

  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

  if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
    color=33   # yellow: dirty
    dirty="*"
  else
    color=32   # green: clean
    dirty=""
  fi

  git_segment=$'\e[1;'"$color"'m'"${project}:${branch}${dirty}"$'\e[0m'
fi

# ---- time segment -------------------------------------------------------
time_segment=$'\e[2m'"$(date +%H:%M)"$'\e[0m'

# ---- context usage segment -----------------------------------------------
ctx_segment=""
if [ -n "$ctx_pct" ]; then
  if [ "$ctx_pct" -ge 80 ]; then
    ctx_color=31   # red: nearly full
  elif [ "$ctx_pct" -ge 50 ]; then
    ctx_color=33   # yellow: filling up
  else
    ctx_color=32   # green: plenty of room
  fi
  ctx_segment=$'\e[1;'"$ctx_color"'m'"ctx:${ctx_pct}%"$'\e[0m'
fi

# ---- model segment ---------------------------------------------------
model_segment=""
[ -n "$model" ] && model_segment=$'\e[2m'"$model"$'\e[0m'

# ---- assemble -------------------------------------------------------------
line="$dir_segment"
[ -n "$git_segment" ] && line="$line | $git_segment"
[ -n "$ctx_segment" ] && line="$line | $ctx_segment"
[ -n "$model_segment" ] && line="$line | $model_segment"
line="$line | $time_segment"

printf '%s\n' "$line"
