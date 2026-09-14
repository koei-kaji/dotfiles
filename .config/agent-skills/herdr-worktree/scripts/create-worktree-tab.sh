#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 <branch> <codex|claude> [base]" >&2
  exit 2
}

[ "$#" -ge 2 ] && [ "$#" -le 3 ] || usage

branch="$1"
agent_kind="$2"
base="${3:-}"

case "$agent_kind" in
  codex|claude) ;;
  *) usage ;;
esac

for command_name in git wt herdr jq; do
  command -v "$command_name" >/dev/null 2>&1 || {
    echo "required command not found: $command_name" >&2
    exit 1
  }
done

[ "${HERDR_ENV:-}" = "1" ] || {
  echo "run this command inside a Herdr pane" >&2
  exit 1
}

workspace_id="${HERDR_WORKSPACE_ID:-}"
[ -n "$workspace_id" ] || {
  echo "HERDR_WORKSPACE_ID is not set" >&2
  exit 1
}

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "current directory is not inside a Git repository" >&2
  exit 1
}

# Reuse an existing worktree for this branch when possible.
list_json="$(wt -C "$repo_root" list --format=json)"
worktree_path="$(
  jq -r --arg branch "$branch" \
    '.items[] | select(.branch == $branch) | .worktree.path' \
    <<<"$list_json" | head -n 1
)"
created=false

if [ -z "$worktree_path" ]; then
  if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
    switch_json="$(
      wt -C "$repo_root" switch --no-cd --format=json "$branch"
    )"
  else
    args=(switch --create --no-cd --format=json "$branch")
    [ -z "$base" ] || args+=(--base "$base")
    switch_json="$(wt -C "$repo_root" "${args[@]}")"
    created=true
  fi

  worktree_path="$(jq -r '.path // empty' <<<"$switch_json")"
fi

[ -n "$worktree_path" ] && [ -d "$worktree_path" ] || {
  echo "Worktrunk did not return a valid worktree path" >&2
  exit 1
}

# Reuse an existing tab whose pane is already rooted in this worktree.
pane_list="$(herdr pane list --workspace "$workspace_id")"
existing_tab_id="$(
  jq -r --arg path "$worktree_path" '
    [.result.panes[]
      | select(((.foreground_cwd // .cwd) // "") == $path)
      | .tab_id][0] // empty
  ' <<<"$pane_list"
)"

if [ -n "$existing_tab_id" ]; then
  herdr tab focus "$existing_tab_id" >/dev/null
  jq -n \
    --arg branch "$branch" \
    --arg path "$worktree_path" \
    --arg workspace_id "$workspace_id" \
    --arg tab_id "$existing_tab_id" \
    --argjson created "$created" \
    '{action:"reused", branch:$branch, path:$path,
      workspace_id:$workspace_id, tab_id:$tab_id,
      worktree_created:$created}'
  exit 0
fi

tab_json="$(
  herdr tab create \
    --workspace "$workspace_id" \
    --cwd "$worktree_path" \
    --label "$branch" \
    --focus
)"

tab_id="$(jq -r '.result.tab.tab_id // empty' <<<"$tab_json")"
pane_id="$(jq -r '.result.root_pane.pane_id // empty' <<<"$tab_json")"

[ -n "$tab_id" ] && [ -n "$pane_id" ] || {
  echo "The worktree was preserved, but Herdr did not return tab and pane IDs." >&2
  echo "worktree: $worktree_path" >&2
  exit 1
}

herdr pane rename "$pane_id" "$branch" >/dev/null

# Herdr agent names must match [a-z][a-z0-9_-]{0,31}.
agent_name="$(
  printf '%s' "$branch" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9_-]+/-/g; s/^[^a-z]+//; s/[^a-z0-9]+$//' \
    | cut -c1-32
)"
[ -n "$agent_name" ] || agent_name="worktree-agent"

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

if ! herdr agent start "$agent_name" \
  --kind "$agent_kind" \
  --pane "$pane_id" \
  --timeout 60000 >/dev/null; then
  echo "The worktree and Herdr tab were preserved, but the agent failed to start." >&2
  echo "worktree: $worktree_path" >&2
  echo "tab: $tab_id" >&2
  echo "pane: $pane_id" >&2
  exit 1
fi

jq -n \
  --arg branch "$branch" \
  --arg path "$worktree_path" \
  --arg workspace_id "$workspace_id" \
  --arg tab_id "$tab_id" \
  --arg pane_id "$pane_id" \
  --arg agent_name "$agent_name" \
  --arg agent_kind "$agent_kind" \
  --argjson created "$created" \
  '{action:"created", branch:$branch, path:$path,
    workspace_id:$workspace_id, tab_id:$tab_id, pane_id:$pane_id,
    agent_name:$agent_name, agent_kind:$agent_kind,
    worktree_created:$created}'
