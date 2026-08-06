# 신규 작업 · 리팩토링 워크플로우

신규 기능 개발 또는 리팩토링을 시작할 때, 아래 순서를 **적극 권고**한다. 각 단계는 [skills.sh](https://www.aihero.dev/skills)(`mattpocock/skills`) 레지스트리의 스킬로 구현되어 있으며, 이 레지스트리는 Claude Code뿐 아니라 Codex·Cursor·Gemini CLI 등 다수의 에이전트 툴에 동일하게 설치된다.

## 워크플로우 순서

**관련 코드베이스가 없는 경우 (순수 신규):**

```
grill-me → to-spec → to-tickets → implement
```

**관련 코드베이스가 있는 경우 (기존 코드 기반):**

```
grill-with-docs → to-spec → to-tickets → implement
```

- `grill-me` / `grill-with-docs`: 요구사항이 구체화되기 전, 질문을 반복하며 모호함을 걷어낸다. `grill-with-docs`는 도메인 모델 정제(용어 challenge) + `CONTEXT.md`/ADR 갱신까지 포함한다.
- `to-spec`: 지금까지의 대화를 스펙으로 정리해 이슈 트래커에 발행한다.
- `to-tickets`: 스펙을 실행 가능한 티켓 단위로 쪼갠다.
- `implement`: 스펙/티켓을 받아 미리 합의한 seam마다 TDD 루프를 돌리고, 완료 후 코드 리뷰(AGENTS.md 10번 참조)를 거쳐 커밋까지 수행하는 마지막 구현 단계다.

## 적용 시점

- 새 기능, 새 모듈, 리팩토링을 시작하는 경우
- 작업 범위가 단일 파일 수정을 넘어서는 경우
- 요구사항이 아직 구체화되지 않은 경우

## 권고 방식

작업 시작 전 다음과 같이 제안한다:

> "이 작업은 `grill-with-docs`(또는 `grill-me`)부터 시작하는 것을 권고합니다. 진행할까요?"

## 스킬 설치 확인

워크플로우를 시작하기 전, 필수 스킬이 설치되어 있는지 확인한다.

**필수 스킬 목록 및 설치 명령:**

전부 `-g`로 전역 설치되며 `~/.agents/skills/`에 저장된 뒤 각 에이전트 툴의 설정 경로로 연결(symlink)된다.

| 스킬 | 설치 명령 |
|------|-----------|
| `grill-me` | `npx skills add mattpocock/skills@grill-me -g -y` |
| `grill-with-docs` | `npx skills add mattpocock/skills@grill-with-docs -g -y` |
| `to-spec` | `npx skills add mattpocock/skills@to-spec -g -y` |
| `to-tickets` | `npx skills add mattpocock/skills@to-tickets -g -y` |
| `implement` | `npx skills add mattpocock/skills@implement -g -y` |
| `tdd` | `npx skills add mattpocock/skills@tdd -g -y` |
| `setup-matt-pocock-skills` | `npx skills add mattpocock/skills@setup-matt-pocock-skills -g -y` |

> `to-spec`/`to-tickets`는 이슈 트래커 설정이 필요하다. 레포에서 최초 1회 `/setup-matt-pocock-skills`(또는 사용 중인 툴의 동등한 스킬 실행 방식)를 실행해 둔다.
>
> 참고: `npx skills add`에 스킬을 여러 개 나열하면 첫 번째만 처리된다. 스킬별로 한 번씩 실행한다.

**확인 명령:**

```bash
ls ~/.agents/skills/ 2>/dev/null
```

**누락된 스킬이 있을 경우:**

해당 스킬의 설치 명령을 실행하고, 설치 후 워크플로우를 진행한다.

스킬 전체 목록은 [aihero.dev/skills](https://www.aihero.dev/skills) 또는 `npx skills find <query>`로 검색한다.

## 컨텍스트 요약 트리거 (선택 패턴)

세션이 길어지거나 다른 에이전트/사람에게 인계할 때, 특정 키워드로 진행 상황을 정형화된 형식으로 요약하게 하는 패턴을 함께 쓴다.

예: 사용자가 "맥락정리"라고 입력하면, 새 작업을 시작하지 말고 지금까지 진행한 내용을 아래 형식으로만 요약한다.

먼저 `git status`로 변경 여부를 확인한다.

- 변경된 파일이 있으면(작업이 진행된 상태): `git diff --stat`까지 확인해 "건드린 파일" 섹션을 실제 변경 내역 기준으로 작성한다.
- working tree가 깨끗하면: git 출력은 생략하고 대화 내용만으로 요약한다.

```
### 목표
이 작업에서 최종적으로 달성하려는 것 (1~2줄)

### 현재 상태
지금까지 한 일 / 어디까지 왔는지

### 핵심 결정 & 이유
무엇을 선택했고 왜 그렇게 했는지 (검토했던 대안 포함)

### 건드린 파일
수정·생성한 주요 파일과 변경 요지

### 다음 할 일
바로 이어서 할 액션. blocker가 있으면 명시.
```

규칙: 각 섹션 1~3줄, 요점만. 확실하지 않은 항목은 추측하지 말고 "불명확"으로 표시.
