#!/bin/bash

set -euo pipefail

LABEL="com.ms.geminiresetping"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
STATE_DIR="$HOME/Library/Application Support/geminiResetPing"
STATE_FILE="$STATE_DIR/last_success_date"

launchctl bootout "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
launchctl disable "gui/$(id -u)/$LABEL" >/dev/null 2>&1 || true
rm -f "$PLIST_PATH"
rm -f "$STATE_FILE"
rmdir "$STATE_DIR" >/dev/null 2>&1 || true

echo "Uninstalled LaunchAgent: $LABEL"
echo "Removed plist: $PLIST_PATH"
