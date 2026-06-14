#!/usr/bin/env bash
# ~/.claude/statusline.sh — Claude Code のステータスライン表示コマンド。
# Claude Code が標準入力へ渡す JSON（statusLine 仕様）を読み取り、複数行の
# ステータス表示を標準出力へ書き出す。1 行 = 1 echo（複数行はそのまま各行に並ぶ）。
#
# レイアウト（空のセクション／行は出さない）:
#   📁 カレントパス（$HOME → ~ に短縮）
#   🐙 リポジトリ名  🌿 ブランチ
#   🧠 コンテキスト [バー] % (トークン量)   💪 モデル  ⚡ effort
#   💰 5h 23% (🔄 2h30m)   7d 41% (🔄 6/16 10am)
#   📊 in:5K  c-in:120K  out:2K   ✏️3 🤖1 🔌0 ✨2

# ---- ANSI カラー（$'...' の ANSI-C クォートで実際の ESC バイトを変数に格納）----
RESET=$'\033[0m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
MAGENTA=$'\033[35m'
BLUE=$'\033[34m'

# ---- jq の場所を特定（まず PATH、無ければ Windows の既知のインストール先を探す）----
if command -v jq &>/dev/null; then
  JQ=jq
else
  for cand in \
    "$HOME/AppData/Local/Microsoft/WinGet/Packages/jqlang.jq_Microsoft.Winget.Source_8wekyb3d8bbwe/jq.exe" \
    "$HOME/scoop/shims/jq.exe" \
    "$HOME/.local/bin/jq.exe" \
    "$HOME/.local/bin/jq"
  do
    [ -x "$cand" ] && JQ="$cand" && break
  done
fi
# jq が見つからなければ最低限のメッセージだけ出して正常終了（ステータスラインは決して落とさない）。
[ -z "${JQ:-}" ] && { printf '%bstatusline: jq not found%b\n' "$RED" "$RESET"; exit 0; }

# ---- ヘルパー関数 ----
sanitize_int() {
  # 名前で渡した変数の値が正の整数でなければ 0 に置き換える（数値計算前の安全策）。
  local val="${!1}"
  case "$val" in *[!0-9]*|"") printf -v "$1" '%s' 0 ;; esac
}

fmt_tokens() {
  # トークン数を読みやすく整形する: 1000 未満はそのまま / 1000 以上は K / 100万以上は M（四捨五入）。
  local n="${1:-0}"
  sanitize_int n
  if [ "$n" -ge 1000000 ]; then
    awk -v x="$n" 'BEGIN { printf "%.1fM", x/1000000 }'
  elif [ "$n" -ge 1000 ]; then
    awk -v x="$n" 'BEGIN { printf "%.0fK", x/1000 }'
  else
    printf '%s' "$n"
  fi
}

fmt_reset() {
  # Unix エポック秒を受け取り、リセットまでの残り時間を人間に読みやすく整形する。
  #   ・24 時間以内 → "2h30m"（残り時間）
  #   ・24 時間超   → "6/16 10am"（リセットの月/日 時刻）
  # 引数が 0／過去なら何も出さない（空文字）。
  local at="$1"
  sanitize_int at
  [ "$at" -le 0 ] && return
  local now remain
  now=$(date +%s)
  remain=$((at - now))
  if [ "$remain" -le 0 ]; then
    return
  elif [ "$remain" -lt 86400 ]; then
    printf '%dh%02dm' "$((remain / 3600))" "$(((remain % 3600) / 60))"
  else
    # LC_TIME=C で am/pm を英語表記に固定（日本語ロケールだと "午後" になるため）。
    # date の書式は GNU/BSD どちらでも -d/-r が異なるため、両方試す。
    local out
    out=$(LC_TIME=C date -r "$at" '+%-m/%-d %-l%p' 2>/dev/null \
          || LC_TIME=C date -d "@$at" '+%-m/%-d %-l%p' 2>/dev/null)
    # "4PM" → "4pm" に小文字化。
    printf '%s' "$out" | tr 'APM' 'apm'
  fi
}

make_bar() {
  # 使用率 %（整数）を受け取り、10 マスのプログレスバー文字列を返す。
  # 例: 42 → "████░░░░░░"
  local pct="$1" width=10
  sanitize_int pct
  [ "$pct" -gt 100 ] && pct=100
  local filled=$((pct * width / 100))
  local empty=$((width - filled))
  local bar=""
  [ "$filled" -gt 0 ] && { printf -v f "%${filled}s"; bar="${f// /█}"; }
  [ "$empty"  -gt 0 ] && { printf -v e "%${empty}s";  bar="${bar}${e// /░}"; }
  printf '%s' "$bar"
}

# ---- 標準入力の JSON を 1 回の jq 呼び出しでまとめてパース ----
# jq(.exe) の起動には ~200ms かかるため、必要な値を 1 回で取り出す。
# 出力する各行が、下の read ブロックと 1 対 1 で対応する（順序を変えるときは read 側も必ず合わせる）。
# 値が無いフィールドは // で既定値（文字列は ""、数値は 0）に落とすので、行数は常に一定。
PARSED=$("$JQ" -r '
  (.workspace.current_dir // .cwd // ""),
  (.workspace.repo.name // ""),
  (.model.display_name // .model.id // "unknown"),
  (.effort.level // ""),
  (.thinking.enabled // false),
  (.context_window.used_percentage // ""),
  (.transcript_path // ""),
  (.context_window.current_usage.input_tokens // 0),
  (.context_window.current_usage.output_tokens // 0),
  (.context_window.current_usage.cache_creation_input_tokens // 0),
  (.context_window.current_usage.cache_read_input_tokens // 0),
  (.context_window.total_input_tokens // 0),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.five_hour.resets_at // 0),
  (.rate_limits.seven_day.used_percentage // ""),
  (.rate_limits.seven_day.resets_at // 0)
' | tr -d '\r')

# 上の jq 出力を 1 行ずつ各変数へ（順序は jq の並びと一致させること）。
{
  IFS= read -r CWD
  IFS= read -r REPO_NAME
  IFS= read -r MODEL
  IFS= read -r EFFORT_LEVEL
  IFS= read -r THINKING_ON
  IFS= read -r USED_PCT
  IFS= read -r TRANSCRIPT
  IFS= read -r Q_INPUT
  IFS= read -r Q_OUTPUT
  IFS= read -r Q_CACHE_CREATE
  IFS= read -r Q_CACHE_READ
  IFS= read -r S_INPUT
  IFS= read -r RATE_5H_PCT
  IFS= read -r RATE_5H_RESETS
  IFS= read -r RATE_7D_PCT
  IFS= read -r RATE_7D_RESETS
} <<< "$PARSED"

# 数値として扱う変数を 0 で安全化（JSON が欠けていた／不正だった場合に備える）。
for v in Q_INPUT Q_OUTPUT Q_CACHE_CREATE Q_CACHE_READ S_INPUT RATE_5H_RESETS RATE_7D_RESETS; do
  sanitize_int "$v"
done

# ====================================================================
# 1 行目: 📁 カレントパス（$HOME → ~ に短縮）
# ====================================================================
LINE_PATH=""
if [ -n "$CWD" ]; then
  disp_path="$CWD"
  case "$disp_path" in
    "$HOME"*) disp_path="~${disp_path#$HOME}" ;;
  esac
  LINE_PATH="📁 ${DIM}${disp_path}${RESET}"
fi

# ====================================================================
# 2 行目: 🐙 リポジトリ名  🌿 ブランチ
# ====================================================================
# Git ブランチ（取れなければ short SHA）。GIT_OPTIONAL_LOCKS=0 で表示のためだけに
# インデックスのロックを取らない（他の git 操作を邪魔しない）。
git_branch=""
if [ -n "$CWD" ]; then
  git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$CWD" symbolic-ref --short HEAD 2>/dev/null \
               || GIT_OPTIONAL_LOCKS=0 git -C "$CWD" rev-parse --short HEAD 2>/dev/null)
fi
# repo.name が JSON に無い場合は CWD のディレクトリ名で代替。
[ -z "$REPO_NAME" ] && [ -n "$CWD" ] && REPO_NAME="${CWD##*/}"

LINE_REPO=""
repo_part=""
branch_part=""
[ -n "$REPO_NAME" ]  && repo_part="🐙 ${BOLD}${MAGENTA}${REPO_NAME}${RESET}"
[ -n "$git_branch" ] && branch_part="🌿 ${CYAN}${git_branch}${RESET}"
if [ -n "$repo_part" ] || [ -n "$branch_part" ]; then
  LINE_REPO="${repo_part}${repo_part:+${branch_part:+  }}${branch_part}"
fi

# ====================================================================
# 3 行目: 🧠 コンテキスト [バー] % (トークン量)   💪 モデル  ⚡ effort
# ====================================================================
# --- コンテキスト ---
#   CTX_TOKENS = total_input_tokens（直前呼び出しの in+cc+cr ＝ 今の履歴の占有量）
#              ＋ current_usage.output_tokens（まだ入力に取り込まれていない最新の応答）。
#   色のしきい値: 50%未満=緑 / 80%未満=黄 / 80%以上=赤。
CTX_TOKENS=$((S_INPUT + Q_OUTPUT))
SECTION_CTX=""
if [ -n "$USED_PCT" ]; then
  PCT_INT=${USED_PCT%.*}
  sanitize_int PCT_INT
  if [ "$PCT_INT" -ge 80 ]; then
    CTX_COLOR="$RED"
  elif [ "$PCT_INT" -ge 50 ]; then
    CTX_COLOR="$YELLOW"
  else
    CTX_COLOR="$GREEN"
  fi
  bar=$(make_bar "$PCT_INT")
  ctx_suffix=""
  [ "$CTX_TOKENS" -gt 0 ] && ctx_suffix=" (${DIM}$(fmt_tokens "$CTX_TOKENS")${RESET})"
  SECTION_CTX="🧠 ${CTX_COLOR}${bar} ${PCT_INT}%${RESET}${ctx_suffix}"
else
  SECTION_CTX="${DIM}🧠 [░░░░░░░░░░] ?%${RESET}"
fi

# --- モデル名（"Claude " 接頭辞を除去し、"(1M context)" → "1M" に短縮）---
MODEL=$(printf '%s' "$MODEL" \
  | sed -E 's/^Claude //; s/\(([0-9]+[KM])[[:space:]]*context\)/\1/; s/[[:space:]]+$//')
SECTION_MODEL="💪 ${BLUE}${MODEL}${RESET}"

# --- Effort レベル / 拡張思考（effort 優先、無ければ thinking）---
SECTION_THINK=""
if [ -n "$EFFORT_LEVEL" ]; then
  SECTION_THINK="⚡ ${MAGENTA}${EFFORT_LEVEL}${RESET}"
elif [ "$THINKING_ON" = "true" ]; then
  SECTION_THINK="⚡ ${MAGENTA}thinking${RESET}"
fi

LINE_CTX=""
for s in "$SECTION_CTX" "$SECTION_MODEL" "$SECTION_THINK"; do
  [ -z "$s" ] && continue
  LINE_CTX="${LINE_CTX:+$LINE_CTX   }$s"
done

# ====================================================================
# 4 行目: 💰 5h 23% (🔄 2h30m)   7d 41% (🔄 6/16 10am)
# ====================================================================
# レート上限（Pro/Max のみ。最初の API 応答以降に出現）。
# 使用率の色: 50%未満=緑 / 80%未満=黄 / 80%以上=赤。
rate_part() {
  # $1=ラベル(5h/7d) $2=used% $3=resets_at。値が無ければ空文字を返す。
  local label="$1" pct="$2" resets="$3"
  [ -z "$pct" ] && return
  local pint=${pct%.*}
  sanitize_int pint
  local color="$GREEN"
  if [ "$pint" -ge 80 ]; then color="$RED"
  elif [ "$pint" -ge 50 ]; then color="$YELLOW"; fi
  local reset_str
  reset_str=$(fmt_reset "$resets")
  printf '%s %s%d%%%s%s' "$label" "$color" "$pint" "$RESET" \
    "${reset_str:+ ${DIM}(🔄 ${reset_str})${RESET}}"
}

LINE_RATE=""
p5h=$(rate_part "5h" "$RATE_5H_PCT" "$RATE_5H_RESETS")
p7d=$(rate_part "7d" "$RATE_7D_PCT" "$RATE_7D_RESETS")
if [ -n "$p5h" ] || [ -n "$p7d" ]; then
  LINE_RATE="💰 ${p5h}${p5h:+${p7d:+   }}${p7d}"
fi

# ====================================================================
# 5 行目: 📊 in:5K  c-in:120K  out:2K   ✏️3 🤖1 🔌0 ✨2
# ====================================================================
# --- 直前クエリの in / c-in / out（クエリの中身 ＋ キャッシュヒット状況）---
#   in    = このクエリで新規に処理した入力（Q_INPUT ＋ cache_creation）。
#   c-in  = cache_read。キャッシュから再利用した分（＝ヒット）。
#   out   = このクエリの出力。
q_in_new=$((Q_INPUT + Q_CACHE_CREATE))
SECTION_QUERY=""
if [ "$q_in_new" -gt 0 ] || [ "$Q_CACHE_READ" -gt 0 ] || [ "$Q_OUTPUT" -gt 0 ]; then
  SECTION_QUERY="in:$(fmt_tokens "$q_in_new")  c-in:$(fmt_tokens "$Q_CACHE_READ")  out:$(fmt_tokens "$Q_OUTPUT")"
fi

# --- 直前クエリのツール実行回数（Edit / Agent / MCP / Skill）---
# 「直前クエリ」の境界 = .message.content が文字列である最も新しい user メッセージ。
# transcript は slurp の前に直近 2000 行へ制限する（性能対策）。
SECTION_TOOLS=""
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  COUNTS=$(tail -n 2000 "$TRANSCRIPT" 2>/dev/null | "$JQ" -sr '
    ([.[] | select(.type=="user" and (.message.content | type=="string"))] | last | .timestamp) as $ts
    | [.[] | select($ts != null and .timestamp > $ts and .message.content)
           | .message.content
           | if type=="array" then .[]? | select(.type=="tool_use") | .name else empty end]
    | "\(([.[] | select(startswith("mcp__"))] | length))|\(([.[] | select(. == "Skill")] | length))|\(([.[] | select(. == "Agent" or . == "Task")] | length))|\(([.[] | select(. == "Edit" or . == "Write" or . == "MultiEdit")] | length))"
  ' 2>/dev/null | tr -d '\r')
  # 出力は "MCP|Skill|Agent|Edit" の順。各カウントを取り出して安全化する。
  IFS='|' read -r MCP_COUNT SKILL_COUNT AGENT_COUNT EDIT_COUNT <<< "$COUNTS"
  for v in MCP_COUNT SKILL_COUNT AGENT_COUNT EDIT_COUNT; do
    sanitize_int "$v"
  done
  SECTION_TOOLS="✏️${EDIT_COUNT} 🤖${AGENT_COUNT} 🔌${MCP_COUNT} ✨${SKILL_COUNT}"
fi

LINE_STATS=""
if [ -n "$SECTION_QUERY" ] || [ -n "$SECTION_TOOLS" ]; then
  LINE_STATS="📊 ${DIM}${SECTION_QUERY}${RESET}${SECTION_QUERY:+${SECTION_TOOLS:+   }}${SECTION_TOOLS}"
fi

# ====================================================================
# 出力: 空でない行だけを順に echo（1 echo = 1 行）
# ====================================================================
for line in "$LINE_PATH" "$LINE_REPO" "$LINE_CTX" "$LINE_RATE" "$LINE_STATS"; do
  [ -z "$line" ] && continue
  printf '%s\n' "$line"
done
