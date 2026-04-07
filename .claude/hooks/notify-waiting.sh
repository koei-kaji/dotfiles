#!/bin/bash
HOOK_INPUT=$(cat)
PROJECT_NAME=$(basename "$PWD")

SUMMARY=$(
  TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // empty')
  if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    TEXT=$(jq -c 'select(.message.role == "assistant") | [.message.content[].text? // empty] | join(" ") | select(. != "")' "$TRANSCRIPT_PATH" | tail -n 1 | jq -r '.')
    echo "$TEXT" | tr '\n' ' ' | cut -c 1-30
  fi
) 2>/dev/null

[ -z "$SUMMARY" ] && SUMMARY="Waiting for input"

terminal-notifier \
  -title "CC Waiting" \
  -subtitle "${PROJECT_NAME}" \
  -message "${SUMMARY}" \
  -sound Blow
