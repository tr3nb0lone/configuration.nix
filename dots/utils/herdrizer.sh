#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
  selected=$1
else # directories I frequently visit
  selected=$(find ~/projects ~/personal ~/BBP/ ~/Work/ ~/Documents/ ~/toolkit/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_label=$(basename "$selected" | tr . _)
workspace_id=""
workspaces_json=""

# Try JSON first (if supported): find workspace with matching cwd.
workspaces_json=$(herdr workspace list --json 2>/dev/null || true)
workspace_id=$(
  HERDR_WORKSPACES_JSON="$workspaces_json" python - "$selected" << 'PY'
import json, sys
import os
selected = sys.argv[1]
raw = os.environ.get("HERDR_WORKSPACES_JSON", "").strip()
if not raw:
    sys.exit(0)
try:
    data = json.loads(raw)
except Exception:
    sys.exit(0)

items = []
if isinstance(data, list):
    items = data
elif isinstance(data, dict):
    for key in ("workspaces", "items", "data"):
        value = data.get(key)
        if isinstance(value, list):
            items = value
            break

for item in items:
    if isinstance(item, dict) and item.get("cwd") == selected:
        wid = item.get("id")
        if wid is not None:
            print(wid)
        break
PY
)

# Fallback parser for non-JSON workspace list output.
if [[ -z $workspace_id ]]; then
  workspace_id=$(herdr workspace list 2>/dev/null | awk -v cwd="$selected" 'index($0, cwd) {print $1; exit}')
fi

if [[ -z $workspace_id ]]; then
  herdr workspace create --cwd "$selected" --label "$selected_label" --focus
else
  herdr workspace focus "$workspace_id"
fi

# Outside Herdr, attach after switching focus.
if [[ -z ${HERDR_ENV:-} ]]; then
  exec herdr
fi
