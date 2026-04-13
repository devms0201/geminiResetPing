#!/bin/bash

set -euo pipefail

if ! command -v gemini >/dev/null 2>&1; then
  echo "Error: 'gemini' command not found in PATH."
  echo "Install Gemini CLI or set PATH correctly before running this script."
  exit 127
fi

echo "[1/2] Running gemini-3.1-pro-preview..."
gemini -m gemini-3.1-pro-preview -p "ping"

echo "[2/2] Running gemini-3-flash-preview..."
gemini -m gemini-3-flash-preview -p "ping"
