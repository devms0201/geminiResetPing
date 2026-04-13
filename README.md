# geminiResetPing

Send `ping` to two Gemini CLI models every day on macOS using `launchd`.

## English

### What It Does

- `ping_gemini.sh`
  - Runs `gemini -m gemini-3.1-pro-preview -p "ping"`
  - Runs `gemini -m gemini-3-flash-preview -p "ping"`
- `install.sh`
  - Creates `~/Library/LaunchAgents/com.ms.geminiresetping.plist`
  - Registers/enables the LaunchAgent
  - Runs every 30 minutes and retries after target time until success
- `uninstall.sh`
  - Unregisters/disables the LaunchAgent
  - Removes the plist file and daily success marker

### Prerequisites

- macOS
- Gemini CLI installed and available in shell PATH (`command -v gemini`)

### Quick Start

```bash
git clone https://github.com/devms0201/geminiResetPing.git
cd geminiResetPing
chmod +x ping_gemini.sh install.sh uninstall.sh
./install.sh
```

- Default target time: `09:00` (macOS local timezone)
- Custom target time example (`08:30`):

```bash
./install.sh 8 30
```

### Verify

Check job status:

```bash
launchctl print gui/$(id -u)/com.ms.geminiresetping
```

Expected key fields:

- `last exit code = 0` means the latest run succeeded
- `StartInterval = 1800` means it wakes every 30 minutes

Meaning of `gui/$(id -u)/com.ms.geminiresetping`:

- `gui/$(id -u)`: your logged-in user launchd domain
- `com.ms.geminiresetping`: LaunchAgent label

Manual run test:

```bash
launchctl kickstart -k gui/$(id -u)/com.ms.geminiresetping
```

Check logs:

```bash
tail -n 100 /tmp/geminiresetping.out
tail -n 100 /tmp/geminiresetping.err
```

### Notes

- This is a user LaunchAgent (`gui/...`), so it runs in your logged-in user session.
- Re-running `./install.sh` replaces the existing settings for the same label.
- Behavior:
  - Before target time: skip
  - After target time: retry every 30 minutes until success
  - After first success of the day: skip remaining runs for that day

### Uninstall

```bash
./uninstall.sh
```

- Log files in `/tmp` are not removed automatically.

---

Gemini CLI 모델 2개에 `ping`을 보내는 스크립트를 macOS `launchd`로 매일 실행합니다.

## 한국어

### 하는 일

- `ping_gemini.sh`
  - `gemini -m gemini-3.1-pro-preview -p "ping"` 실행
  - `gemini -m gemini-3-flash-preview -p "ping"` 실행
- `install.sh`
  - `~/Library/LaunchAgents/com.ms.geminiresetping.plist` 생성
  - LaunchAgent 등록/활성화
  - 30분마다 실행되며 목표 시각 이후 성공할 때까지 재시도
- `uninstall.sh`
  - LaunchAgent 등록 해제/비활성화
  - plist 파일 및 당일 성공 마커 삭제

### 사전 조건

- macOS
- Gemini CLI 설치 및 PATH 인식 (`command -v gemini`)

### 빠른 시작

```bash
git clone https://github.com/devms0201/geminiResetPing.git
cd geminiResetPing
chmod +x ping_gemini.sh install.sh uninstall.sh
./install.sh
```

- 기본 목표 시각: `09:00` (macOS 로컬 타임존 기준)
- 시간 지정 예시 (`08:30`):

```bash
./install.sh 8 30
```

### 확인 방법

등록 상태 확인:

```bash
launchctl print gui/$(id -u)/com.ms.geminiresetping
```

정상 확인 포인트:

- `last exit code = 0` 이면 최근 실행 성공
- `StartInterval = 1800` 이면 30분 주기 실행

`gui/$(id -u)/com.ms.geminiresetping` 의미:

- `gui/$(id -u)`: 현재 로그인 사용자 launchd 도메인
- `com.ms.geminiresetping`: LaunchAgent 라벨 이름

즉시 실행 테스트:

```bash
launchctl kickstart -k gui/$(id -u)/com.ms.geminiresetping
```

로그 확인:

```bash
tail -n 100 /tmp/geminiresetping.out
tail -n 100 /tmp/geminiresetping.err
```

### 참고

- 이 작업은 사용자 LaunchAgent(`gui/...`)라 로그인한 사용자 세션 기준으로 동작합니다.
- `./install.sh`를 다시 실행하면 같은 라벨의 기존 설정을 교체합니다.
- 동작 방식:
  - 목표 시각 이전: 실행 건너뜀
  - 목표 시각 이후: 성공할 때까지 30분마다 재시도
  - 당일 첫 성공 이후: 같은 날은 추가 실행 건너뜀

### 제거

```bash
./uninstall.sh
```

- `/tmp` 로그 파일은 자동 삭제하지 않습니다.
