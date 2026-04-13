# TODO

## Goal

사용자가 `chmod` 같은 권한 설정을 직접 하지 않아도 설치 가능하게 만들기.

## Option 1: `bash install.sh` 방식으로 단순화

- 내용
  - README 설치 명령을 `./install.sh` 대신 `bash install.sh`로 변경
  - `install.sh` 내부에서 `ping_gemini.sh`에 실행 권한 부여(`chmod +x`) 유지
- 장점
  - 구현 변경이 거의 없음
  - 사용자 실수(실행 권한 누락) 감소
- 단점
  - 여전히 사용자가 `bash install.sh` 명령은 알아야 함

## Option 2: `make install` 인터페이스 추가

- 내용
  - `Makefile` 추가
  - `install`, `uninstall`, `status`, `logs` 타겟 제공
  - 내부적으로 `bash install.sh`/`bash uninstall.sh` 호출
- 장점
  - 명령이 직관적이고 문서화가 쉬움
  - 설치/점검/삭제 작업을 표준화 가능
- 단점
  - `make` 의존성 추가(대부분 macOS 기본 포함이지만 환경별 확인 필요)

