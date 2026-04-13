# geminiResetPing

This project schedules a script that sends `ping` prompts to two Gemini CLI models every day using macOS `launchd`.

## What It Does (EN)

- `ping_gemini.sh`:
  - Runs `gemini-3.1-pro-preview`
  - Runs `gemini-3-flash-preview`
- `install.sh`:
  - Creates and registers a LaunchAgent
  - Schedules daily execution at the chosen time
- `uninstall.sh`:
  - Removes the LaunchAgent

## Prerequisite (EN)

- macOS
- `gemini` CLI must be installed (`command -v gemini` succeeds)

## Quick Start (EN)

Default schedule (every day at 09:00):

```bash
cd /Users/ms/Projects/geminiResetPing
chmod +x ping_gemini.sh install.sh uninstall.sh
./install.sh
```

Custom schedule (example: 08:30):

```bash
./install.sh 8 30
```

## Verify (EN)

Check registration status:

```bash
launchctl print gui/$(id -u)/com.ms.geminiresetping
```

Run immediately for testing:

```bash
launchctl kickstart -k gui/$(id -u)/com.ms.geminiresetping
```

Check logs:

```bash
tail -n 100 /tmp/geminiresetping.out
tail -n 100 /tmp/geminiresetping.err
```

## Uninstall (EN)

```bash
./uninstall.sh
```

---

Gemini CLI 모델 2개에 `ping`을 보내는 스크립트를 macOS `launchd`로 매일 자동 실행하는 프로젝트입니다.

## What It Does

- `ping_gemini.sh`:
  - `gemini-3.1-pro-preview` 실행
  - `gemini-3-flash-preview` 실행
- `install.sh`:
  - LaunchAgent 생성/등록
  - 매일 지정 시각에 실행되도록 스케줄링
- `uninstall.sh`:
  - LaunchAgent 제거

## Prerequisite

- macOS
- `gemini` CLI가 설치되어 있어야 함 (`command -v gemini` 성공)

## Quick Start

기본값(매일 09:00):

```bash
cd /Users/ms/Projects/geminiResetPing
chmod +x ping_gemini.sh install.sh uninstall.sh
./install.sh
```

원하는 시각 지정(예: 08:30):

```bash
./install.sh 8 30
```

## Verify

등록 상태 확인:

```bash
launchctl print gui/$(id -u)/com.ms.geminiresetping
```

즉시 수동 실행 테스트:

```bash
launchctl kickstart -k gui/$(id -u)/com.ms.geminiresetping
```

로그 확인:

```bash
tail -n 100 /tmp/geminiresetping.out
tail -n 100 /tmp/geminiresetping.err
```

## Uninstall

```bash
./uninstall.sh
```
