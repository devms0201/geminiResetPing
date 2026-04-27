#!/bin/bash

set -euo pipefail

TARGET_HOUR="${TARGET_HOUR:-9}"
TARGET_MINUTE="${TARGET_MINUTE:-0}"
STATE_DIR="$HOME/Library/Application Support/geminiResetPing"
STATE_FILE="$STATE_DIR/last_success_date"
FORCE_RUN="${1:-}"

if ! [[ "$TARGET_HOUR" =~ ^[0-9]+$ ]] || ! [[ "$TARGET_MINUTE" =~ ^[0-9]+$ ]]; then
  echo "Error: TARGET_HOUR/TARGET_MINUTE must be numeric."
  exit 1
fi

if (( TARGET_HOUR < 0 || TARGET_HOUR > 23 || TARGET_MINUTE < 0 || TARGET_MINUTE > 59 )); then
  echo "Error: TARGET_HOUR must be 0-23 and TARGET_MINUTE must be 0-59."
  exit 1
fi

if ! command -v gemini >/dev/null 2>&1; then
  echo "Error: 'gemini' command not found in PATH."
  echo "Install Gemini CLI or set PATH correctly before running this script."
  exit 127
fi

today="$(date +%F)"
now_minutes=$((10#$(date +%H) * 60 + 10#$(date +%M)))
target_minutes=$((TARGET_HOUR * 60 + TARGET_MINUTE))

if [[ "$FORCE_RUN" != "--force" ]]; then
  if (( now_minutes < target_minutes )); then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Skip: current time is before $(printf '%02d:%02d' "$TARGET_HOUR" "$TARGET_MINUTE")."
    exit 0
  fi

  if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "$today" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Skip: already succeeded today ($today)."
    exit 0
  fi
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [1/2] Running gemini-3.1-pro-preview..."
gemini -m gemini-3.1-pro-preview -p "ping"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [2/2] Running gemini-3-flash-preview..."
gemini -m gemini-3-flash-preview -p "ping"

mkdir -p "$STATE_DIR"
printf '%s\n' "$today" > "$STATE_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Success: marked completion for $today."
