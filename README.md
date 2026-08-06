# AI Agent Playbook

AI 코딩 에이전트(Claude Code, Codex, Cursor, Gemini CLI 등)와 함께 작업할 때 쓰는 개인 운영 지침과 워크플로우 모음이다. 특정 도구에 종속되지 않도록 [AGENTS.md](https://agents.md) 표준을 기반으로 정리했다 — 어떤 에이전트를 쓰든 같은 규칙, 같은 워크플로우를 그대로 적용할 수 있다.

## 왜 만들었나

에이전트마다 지침 파일 형식(`CLAUDE.md`, `.cursor/rules`, `GEMINI.md` ...)과 훅/스킬 메커니즘이 달라서, 도구를 바꾸거나 새 환경을 세팅할 때마다 같은 규칙을 다시 손으로 옮겨 적게 된다. 이 레포는 그 규칙의 **단일 진실 공급원**을 도구 중립적인 `AGENTS.md` 하나로 유지하고, 새 환경에서 한 번에 적용할 수 있게 만든 것이다.

프로젝트 고유의 스펙·이슈·도메인 지식은 여기 포함하지 않는다. 여기 있는 건 어떤 프로젝트에도 들고 갈 수 있는 **일하는 방식**뿐이다.

## 구성

```
AGENTS.md                     범용 에이전트 지침 원본 (단일 진실 공급원)
docs/
  project-structure.md        프로젝트별 지침 파일을 어디에 어떻게 둘지에 대한 규약
  workflow.md                 신규 기능/리팩토링 착수 워크플로우 (질문 → 스펙 → 티켓 → 구현)
setup.sh                      새 환경 부트스트랩 스크립트
```

## 핵심 철학

- **구현보다 합의가 먼저다.** 가정을 명시하고, 모호하면 대안을 제시하고, 확신 없으면 질문한다 (`AGENTS.md` 1, 5번).
- **작은 변경, 명확한 경계.** 요청 범위 밖은 건드리지 않는다. 리팩토링과 기능 변경은 분리한다 (`AGENTS.md` 2, 3번).
- **완료는 검증으로 증명한다.** "될 것 같다"가 아니라 실행해서 통과를 확인한 것만 완료로 친다 (`AGENTS.md` 4, 7번).
- **비가역 작업엔 브레이크를 건다.** `force-push`, `rm -rf`, 프로덕션 배포류는 에이전트가 판단만으로 실행하지 않는다 (`AGENTS.md` 6번).
- **도구가 아니라 워크플로우를 표준화한다.** 질문(grill) → 스펙 → 티켓 → 구현(TDD) 순서는 어떤 에이전트에서도 동일하게 굴러간다 (`docs/workflow.md`).

## 새 환경에서 적용하기

```bash
git clone <this-repo> ~/ai-agent-playbook
cd ~/ai-agent-playbook
./setup.sh
```

`setup.sh`는 다음을 수행한다:

1. `AGENTS.md`를 주요 에이전트 툴의 전역 설정 경로에 심링크한다 (이미 실제 파일이 있으면 덮어쓰지 않고 건너뛴다).
2. `grill-me → to-spec → to-tickets → implement` 워크플로우에 쓰는 스킬을 [`mattpocock/skills`](https://www.aihero.dev/skills) 레지스트리에서 전역 설치한다.

프로젝트 레포에서는 `docs/project-structure.md` 규약대로 루트에 `AGENTS.md`를 두고, 필요하면 도구별 진입점 파일(`CLAUDE.md` 등)이 그것을 가리키게 한다.

## 출처 및 라이선스 관련 메모

- 워크플로우 스킬(`grill-me`, `to-spec`, `to-tickets`, `implement`, `tdd` 등)은 이 레포의 소유물이 아니라 [mattpocock/skills](https://github.com/mattpocock/skills)에서 설치해 쓰는 오픈소스 스킬이다. 여기서는 스킬 원문을 복제하지 않고 설치 방법과 사용 방식만 문서화했다.
- `AGENTS.md`, `docs/` 하위 문서는 직접 작성/편집한 운영 지침이다.
