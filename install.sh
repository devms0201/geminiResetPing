#!/bin/bash

set -euo pipefail

LABEL="com.ms.geminiresetping"
HOUR="${1:-9}"
MINUTE="${2:-0}"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/ping_gemini.sh"
OUT_LOG="/tmp/geminiresetping.out"
ERR_LOG="/tmp/geminiresetping.err"

if ! [[ "$HOUR" =~ ^[0-9]+$ ]] || ! [[ "$MINUTE" =~ ^[0-9]+$ ]]; then
  echo "Usage: ./install.sh [hour] [minute]"
  echo "Example: ./install.sh 9 0"
  exit 1
fi

if (( HOUR < 0 || HOUR > 23 || MINUTE < 0 || MINUTE > 59 )); then
  echo "Error: hour must be 0-23 and minute must be 0-59."
  exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents"
chmod +x "$TARGET_SCRIPT"

if ! command -v gemini >/dev/null 2>&1; then
  echo "Error: 'gemini' command not found."
  echo "Install Gemini CLI first, then run this installer again."
  exit 127
fi

GEMINI_BIN="$(command -v gemini)"
GEMINI_DIR="$(dirname "$GEMINI_BIN")"

cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>$LABEL</string>

    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>$TARGET_SCRIPT</string>
    </array>

    <key>StartCalendarInterval</key>
    <dict>
      <key>Hour</key>
      <integer>$HOUR</integer>
      <key>Minute</key>
      <integer>$MINUTE</integer>
    </dict>

    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>$GEMINI_DIR:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>

    <key>StandardOutPath</key>
    <string>$OUT_LOG</string>
    <key>StandardErrorPath</key>
    <string>$ERR_LOG</string>

    <key>RunAtLoad</key>
    <false/>
  </dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"
launchctl enable "gui/$(id -u)/$LABEL"

echo "Installed LaunchAgent: $LABEL"
echo "Schedule: daily $(printf '%02d:%02d' "$HOUR" "$MINUTE")"
echo "plist: $PLIST_PATH"
echo "stdout: $OUT_LOG"
echo "stderr: $ERR_LOG"
echo "Manual test: launchctl kickstart -k gui/$(id -u)/$LABEL"
