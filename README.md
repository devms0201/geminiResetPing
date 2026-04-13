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
  - Schedules daily run at a chosen hour/minute
- `uninstall.sh`
  - Unregisters/disables the LaunchAgent
  - Removes the plist file

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

- Default schedule: daily `09:00` (macOS local timezone)
- Custom schedule example (`08:30`):

```bash
./install.sh 8 30
```

### Verify

Check job status:

```bash
launchctl print gui/$(id -u)/com.ms.geminiresetping
```

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
- Re-running `./install.sh` replaces the existing schedule for the same label.

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
  - 지정한 시각으로 매일 스케줄 설정
- `uninstall.sh`
  - LaunchAgent 등록 해제/비활성화
  - plist 파일 삭제

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

- 기본 스케줄: 매일 `09:00` (macOS 로컬 타임존 기준)
- 시간 지정 예시 (`08:30`):

```bash
./install.sh 8 30
```

### 확인 방법

등록 상태 확인:

```bash
launchctl print gui/$(id -u)/com.ms.geminiresetping
```

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
- `./install.sh`를 다시 실행하면 같은 라벨의 기존 스케줄을 교체합니다.

### 제거

```bash
./uninstall.sh
```

- `/tmp` 로그 파일은 자동 삭제하지 않습니다.
