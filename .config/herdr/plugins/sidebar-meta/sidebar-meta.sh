#!/usr/bin/env bash
# =============================================================================
# herdr sidebar metadata reporter
#
# herdr の sidebar には「番号」と「space 内の tab 一覧」の組み込みトークンが無く、
# 複数トークンを並べると herdr が " · " を挟んで横幅を食う。そこで socket API から
# 状態を読み、行ごと 1 つの display-only メタデータ ($トークン) として report する。
#
#   spaces : $head        "○  1 student"   (状態グリフ + 番号 + space 名)
#            $tab1..$tabN "├ ○ task/FOO"   (space 内の tab 一覧)
#   agents : $head        "○  1 student"
#
# agent state は色ではなく形の違うグリフで示す (色覚に依存しない表示にするため)。
#
# herdr はトークン値の先頭空白を (U+00A0 や U+2007 も含め) すべてトリムするので、
# 行頭は必ず空白以外の文字から始める。桁揃えとインデントはそのための工夫:
#   - 番号の桁揃え: 先頭にグリフを置き、数字の前に FIGURE SPACE (U+2007) を入れる
#   - tab のインデント: 先頭にツリー記号 ├ / └ を置く
#
# 対応する $トークンを config.toml の [ui.sidebar.*] rows に並べておくこと。
#
# 使い方:
#   sidebar-meta.sh            フォアグラウンドで常駐 (デバッグ用)
#   sidebar-meta.sh --once     1 回だけ report して終了
#   sidebar-meta.sh --daemon   デタッチして常駐 (herdr plugin の startup hook 用)
#   sidebar-meta.sh --stop     常駐プロセスを停止
# =============================================================================

set -uo pipefail

# 連想配列を使うため bash 4+ が要る。macOS 同梱の 3.2 なら再実行する。
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  for candidate in /opt/homebrew/bin/bash /usr/local/bin/bash; do
    [ -x "$candidate" ] && exec "$candidate" "$0" "$@"
  done
  printf 'sidebar-meta: bash 4+ が必要です\n' >&2
  exit 1
fi

readonly SOURCE="sidebar-meta"
readonly HERDR="${HERDR_BIN_PATH:-herdr}"
readonly INTERVAL="${HERDR_SIDEBAR_META_INTERVAL:-2}"
readonly MAX_TABS="${HERDR_SIDEBAR_META_MAX_TABS:-8}"
# 全再送するイテレーション間隔。server 再起動でメタデータが消えた場合の復旧と
# ブランチキャッシュの更新を兼ねる。
readonly RESYNC_EVERY="${HERDR_SIDEBAR_META_RESYNC_EVERY:-30}"
# snapshot 取得がこの回数だけ連続で失敗したら herdr server が落ちたとみなして終了する。
readonly MAX_FAILURES="${HERDR_SIDEBAR_META_MAX_FAILURES:-10}"

readonly RUNTIME_DIR="${TMPDIR:-/tmp}"
readonly LOCKDIR="${RUNTIME_DIR}/herdr-sidebar-meta.lock"
readonly PIDFILE="${LOCKDIR}/pid"
readonly LOGFILE="${RUNTIME_DIR}/herdr-sidebar-meta.log"

# U+2007 FIGURE SPACE。数字 1 文字分の幅を持つので桁揃えに使える。
readonly DIGIT_PAD=$' '

# 直近に report した内容。差分があるときだけ socket を叩く。
declare -A SENT
# cwd -> ブランチ名。"-" は git リポジトリでなかったことを表す。
declare -A BRANCH
# workspace_id -> space 名。agent 行の組み立てに使う。
declare -A WS_LABEL

glyph() {
  case "$1" in
    blocked) printf '▲' ;;
    working) printf '◐' ;;
    done)    printf '✔' ;;
    idle)    printf '○' ;;
    *)       printf '·' ;;
  esac
}

branch_of() {
  local cwd="$1" name
  [ -n "$cwd" ] || return 0
  if [ -z "${BRANCH[$cwd]+x}" ]; then
    name=$(git -C "$cwd" branch --show-current 2>/dev/null)
    BRANCH[$cwd]="${name:--}"
  fi
  [ "${BRANCH[$cwd]}" = "-" ] || printf '%s' "${BRANCH[$cwd]}"
}

# "○  1 student" / "○ 10 coaching-scripts" — 1 桁の番号は FIGURE SPACE で埋める。
head_line() {
  local num="$1" pad=""
  [ "${#num}" -lt 2 ] && pad="$DIGIT_PAD"
  printf '%s %s%s %s' "$(glyph "$2")" "$pad" "$num" "$3"
}

# snapshot を TSV に落とす。
#   W <workspace_id> <number> <agent_status> <label>
#   T <workspace_id> <tab_id> <number> <agent_status> <label> <cwd>
#   A <pane_id> <index> <workspace_id> <agent_status>
readonly SNAPSHOT_FILTER='
  .result.snapshot as $s
  | ($s.panes | reverse | map({(.tab_id): .cwd}) | add // {}) as $cwd
  | ($s.workspaces[] | "W\t\(.workspace_id)\t\(.number)\t\(.agent_status)\t\(.label)"),
    ($s.tabs[] | "T\t\(.workspace_id)\t\(.tab_id)\t\(.number)\t\(.agent_status)\t\(.label)\t\($cwd[.tab_id] // "")"),
    ($s.agents | to_entries[] | "A\t\(.value.pane_id)\t\(.key + 1)\t\(.value.workspace_id)\t\(.value.agent_status)")
'

report_if_changed() {
  local key="$1" payload="$2"
  shift 2
  [ "${SENT[$key]-}" = "$payload" ] && return 0
  "$HERDR" "$@" >/dev/null 2>&1 && SENT[$key]="$payload"
}

sync_once() {
  local data
  data=$("$HERDR" api snapshot 2>/dev/null | jq -r "$SNAPSHOT_FILTER" 2>/dev/null) || return 1
  [ -n "$data" ] || return 1

  local ws num status label branch name args payload lines i last
  local _k tws tid tnum tstatus tlabel tcwd pane idx

  WS_LABEL=()
  while IFS=$'\t' read -r _k ws num status label; do
    WS_LABEL[$ws]="$label"
  done < <(printf '%s\n' "$data" | awk -F'\t' '$1 == "W"')

  while IFS=$'\t' read -r _k ws num status label; do
    lines=()
    while IFS=$'\t' read -r _k tws tid tnum tstatus tlabel tcwd; do
      [ "${#lines[@]}" -lt "$MAX_TABS" ] || break
      # tab 名が既定のまま (数字だけ) なら worktree のブランチ名で代替する。
      name="$tlabel"
      if [[ "$tlabel" =~ ^[0-9]+$ ]]; then
        branch=$(branch_of "$tcwd")
        [ -n "$branch" ] && name="$branch"
      fi
      lines+=("$(glyph "$tstatus") ${name}")
    done < <(printf '%s\n' "$data" | awk -F'\t' -v w="$ws" '$1 == "T" && $2 == w')

    args=()
    last=$((${#lines[@]} - 1))
    for i in "${!lines[@]}"; do
      if [ "$i" -eq "$last" ]; then
        args+=(--token "tab$((i + 1))=└ ${lines[$i]}")
      else
        args+=(--token "tab$((i + 1))=├ ${lines[$i]}")
      fi
    done
    # tab が減ったときに古い行が残らないよう、余りは明示的に消す。
    for ((i = ${#lines[@]} + 1; i <= MAX_TABS; i++)); do
      args+=(--clear-token "tab${i}")
    done

    payload="$(head_line "$num" "$status" "$label")|${args[*]}"
    report_if_changed "ws:${ws}" "$payload" \
      workspace report-metadata "$ws" --source "$SOURCE" \
      --token "head=$(head_line "$num" "$status" "$label")" "${args[@]}"
  done < <(printf '%s\n' "$data" | awk -F'\t' '$1 == "W"')

  while IFS=$'\t' read -r _k pane idx ws status; do
    payload="$(head_line "$idx" "$status" "${WS_LABEL[$ws]-}")"
    report_if_changed "pane:${pane}" "$payload" \
      pane report-metadata "$pane" --source "$SOURCE" --token "head=${payload}"
  done < <(printf '%s\n' "$data" | awk -F'\t' '$1 == "A"')
}

run_loop() {
  local ticks=0 failures=0
  while :; do
    if [ "$ticks" -ge "$RESYNC_EVERY" ]; then
      SENT=()
      BRANCH=()
      ticks=0
    fi
    if sync_once; then
      failures=0
    else
      failures=$((failures + 1))
      # herdr server が落ちたら道連れで終了し、孤児プロセスを残さない。
      if [ "$failures" -ge "$MAX_FAILURES" ]; then
        printf '%s herdr server に %d 回連続で接続できませんでした。終了します。\n' \
          "$(date '+%F %T')" "$failures" >&2
        return 0
      fi
    fi
    ticks=$((ticks + 1))
    sleep "$INTERVAL"
  done
}

# pidfile が生きているプロセスを指していれば pid を返す。
running_pid() {
  local pid
  pid=$(cat "$PIDFILE" 2>/dev/null)
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  kill -0 "$pid" 2>/dev/null || return 1
  printf '%s' "$pid"
}

# mkdir はアトミックなので、同時に起動しても 1 プロセスしかロックを取れない。
# 「存在チェック → pidfile 書き込み」の 2 段構えだと隙間で多重起動する (実測済み)。
acquire_lock() {
  if mkdir "$LOCKDIR" 2>/dev/null; then
    printf '%s' "$$" > "$PIDFILE"
    return 0
  fi
  # 残っているロックが死んだプロセスのものなら回収して取り直す。
  running_pid >/dev/null && return 1
  rm -rf "$LOCKDIR"
  mkdir "$LOCKDIR" 2>/dev/null || return 1
  printf '%s' "$$" > "$PIDFILE"
}

# ロックを握ったまま本体を回す。exit 時に必ずロックを解放する。
run_locked() {
  if ! acquire_lock; then
    printf 'sidebar-meta: 既に pid %s で稼働中です\n' "$(running_pid)" >&2
    exit 0
  fi
  trap 'rm -rf "$LOCKDIR"' EXIT
  run_loop
}

# startup hook から呼ばれる。デタッチして即 return し、herdr の起動を止めない。
# 実際の多重起動防止は子プロセス側の acquire_lock が担う。
start_daemon() {
  local pid
  if pid=$(running_pid); then
    printf 'sidebar-meta: 既に pid %s で稼働中です\n' "$pid"
    return 0
  fi
  nohup "$0" --supervised >>"$LOGFILE" 2>&1 &
  disown 2>/dev/null || true
  printf 'sidebar-meta: pid %s で起動しました (log: %s)\n' "$!" "$LOGFILE"
}

stop_daemon() {
  local pid
  if pid=$(running_pid); then
    kill "$pid" 2>/dev/null
    printf 'sidebar-meta: pid %s を停止しました\n' "$pid"
  else
    printf 'sidebar-meta: 稼働中のプロセスはありません\n'
  fi
  rm -rf "$LOCKDIR"
}

case "${1-}" in
  --once)       sync_once ;;
  --daemon)     start_daemon ;;
  --stop)       stop_daemon ;;
  --supervised) run_locked ;;
  "")           run_locked ;;
  *)            printf 'usage: %s [--once|--daemon|--stop]\n' "$(basename "$0")" >&2; exit 2 ;;
esac
