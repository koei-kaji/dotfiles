#!/bin/bash

# stdin から JSON を読み取り、session_id を抽出
session_id=$(jq -r '.session_id' < /dev/stdin)

# 環境変数として設定
if [ -n "$CLAUDE_ENV_FILE" ] && [ -n "$session_id" ]; then
  echo "export CLAUDE_SESSION_ID=$session_id" >> "$CLAUDE_ENV_FILE"
fi

echo "CLAUDE_SESSION_ID=$session_id"

exit 0
