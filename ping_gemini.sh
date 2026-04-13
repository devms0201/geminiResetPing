#!/bin/bash

echo "[1/2] gemini-3.1-pro-preview 모델 실행 중..."
gemini -m gemini-3.1-pro-preview -p "ping"

echo "[2/2] gemini-3-flash-preview 모델 실행 중..."
gemini -m gemini-3-flash-preview -p "ping"
