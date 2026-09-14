#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 <codex|claude> <name> [right|down] [ratio] [prompt]" >&2
  exit 2
}

[ "$#" -ge 2 ] && [ "$#" -le 5 ] || usage

agent_kind="$1"
requested_name="$2"
direction="${3:-right}"
ratio="${4:-0.5}"
prompt="${5:-}"

case "$agent_kind" in
  codex|claude) ;;
  *) usage ;;
esac

case "$direction" in
  right|down) ;;
  *) usage ;;
esac

for command_name in herdr jq; do
  command -v "$command_name" >/dev/null 2>&1 || {
    echo "required command not found: $command_name" >&2
    exit 1
  }
done

[ "${HERDR_ENV:-}" = "1" ] || {
  echo "run this command inside a Herdr pane" >&2
  exit 1
}

source_pane_id="${HERDR_PANE_ID:-}"
[ -n "$source_pane_id" ] || {
  echo "HERDR_PANE_ID is not set" >&2
  exit 1
}

awk -v ratio="$ratio" 'BEGIN {
  if (ratio !~ /^[0-9]+([.][0-9]+)?$/ || ratio <= 0 || ratio >= 1) exit 1
}' || {
  echo "ratio must be a number greater than 0 and less than 1" >&2
  exit 2
}

agent_name="$(
  printf '%s' "$requested_name" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9_-]+/-/g; s/^[^a-z]+//; s/[^a-z0-9]+$//' \
    | cut -c1-32
)"
[ -n "$agent_name" ] || {
  echo "name must contain at least one ASCII letter" >&2
  exit 2
}

taken_names="$(
  herdr agent list 2>/dev/null \
    | jq -r '.result.agents[]?.name // empty' 2>/dev/null \
    || true
)"

base_name="$agent_name"
suffix=2
while grep -qxF "$agent_name" <<<"$taken_names"; do
  suffix_text="-$suffix"
  max_base_length=$((32 - ${#suffix_text}))
  agent_name="${base_name:0:max_base_length}${suffix_text}"
  suffix=$((suffix + 1))
done

split_json="$(
  herdr pane split \
    --pane "$source_pane_id" \
    --direction "$direction" \
    --ratio "$ratio" \
    --cwd "$PWD" \
    --focus
)"

pane_id="$(jq -r '.result.pane.pane_id // empty' <<<"$split_json")"
[ -n "$pane_id" ] || {
  echo "Herdr did not return the new pane ID" >&2
  exit 1
}

herdr pane rename "$pane_id" "$agent_name" >/dev/null

if ! herdr agent start "$agent_name" \
  --kind "$agent_kind" \
  --pane "$pane_id" \
  --timeout 60000 >/dev/null; then
  echo "The pane was preserved, but the agent failed to start." >&2
  echo "pane: $pane_id" >&2
  exit 1
fi

if [ -n "$prompt" ]; then
  herdr agent prompt "$agent_name" "$prompt" >/dev/null
fi

jq -n \
  --arg pane_id "$pane_id" \
  --arg agent_name "$agent_name" \
  --arg agent_kind "$agent_kind" \
  --arg direction "$direction" \
  --arg ratio "$ratio" \
  '{action:"started", pane_id:$pane_id, agent_name:$agent_name,
    agent_kind:$agent_kind, direction:$direction, ratio:$ratio}'
