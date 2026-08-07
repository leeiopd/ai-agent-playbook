# AI Agent Playbook

AI 코딩 에이전트(Claude Code, Codex, Cursor, Gemini CLI 등)와 함께 작업할 때 쓰는 개인 운영 지침과 워크플로우 모음이다. 특정 도구에 종속되지 않도록 [AGENTS.md](https://agents.md) 표준을 기반으로 정리했다 — 어떤 에이전트를 쓰든 같은 규칙, 같은 워크플로우를 그대로 적용할 수 있다.

## 왜 만들었나

에이전트마다 지침 파일 형식(`CLAUDE.md`, `.cursor/rules`, `GEMINI.md` ...)과 훅/스킬 메커니즘이 달라서, 도구를 바꾸거나 새 환경을 세팅할 때마다 같은 규칙을 다시 손으로 옮겨 적게 된다. 이 레포는 그 규칙의 **단일 진실 공급원**을 도구 중립적인 `AGENTS.md` 하나로 유지하고, 새 환경에서 한 번에 적용할 수 있게 만든 것이다.

프로젝트 고유의 스펙·이슈·도메인 지식은 여기 포함하지 않는다. 여기 있는 건 어떤 프로젝트에도 들고 갈 수 있는 **일하는 방식**뿐이다.

## 구성

```
AGENTS.md                     범용 에이전트 지침 원본 — 항상 적용되는 핵심 규칙만 (단일 진실 공급원)
docs/
  project-structure.md        프로젝트별 지침 파일을 어디에 어떻게 둘지에 대한 규약
  workflow.md                 신규 기능/리팩토링 착수 워크플로우 (질문 → 스펙 → 티켓 → 구현)
  impact-scope.md             기존 코드 수정 전 영향 범위 파악 체크리스트 (특정 상황에서만 필요)
  code-review.md              코드 리뷰 모드 전체 절차·기준·출력 형식 (리뷰 요청 시에만 필요)
  design-discipline.md        깊은 모듈·seam 설계 규율 (새 모듈 설계 시에만 필요)
setup.sh                      새 환경 부트스트랩 스크립트
```

`AGENTS.md`는 항상 로드되므로 최소로 유지하고, 특정 상황에서만 필요한 규칙은 `docs/`로 분리했다 — 프론티어 LLM이 일관되게 따를 수 있는 지침 개수(대략 150~200개)에는 한계가 있다는 [AGENTS.md 작성 가이드](https://www.aihero.dev/a-complete-guide-to-agents-md)의 조언을 따른 것이다.

## 핵심 철학

- **구현보다 합의가 먼저다.** 가정을 명시하고, 모호하면 대안을 제시하고, 확신 없으면 질문한다 (`AGENTS.md` 1, 5번).
- **작은 변경, 명확한 경계.** 요청 범위 밖은 건드리지 않는다. 리팩토링과 기능 변경은 분리한다 (`AGENTS.md` 2, 3번).
- **완료는 검증으로 증명한다.** "될 것 같다"가 아니라 실행해서 통과를 확인한 것만 완료로 친다 (`AGENTS.md` 4, 7번).
- **비가역 작업엔 브레이크를 건다.** `force-push`, `rm -rf`, 프로덕션 배포류는 에이전트가 판단만으로 실행하지 않는다 (`AGENTS.md` 6번).
- **도구가 아니라 워크플로우를 표준화한다.** 질문(grill) → 스펙 → 티켓 → 구현(TDD) 순서는 어떤 에이전트에서도 동일하게 굴러간다 (`docs/workflow.md`).

## 설계 배경: DDD의 전략적·전술적 설계 흐름을 참조

지침의 구조는 도메인 주도 설계(DDD)의 두 층위를 참조했다.

- **전략적 설계(Strategic Design)**: `CONTEXT.md`를 유비쿼터스 랭귀지(ubiquitous language)의 저장소로 두고, 새 기능·새 도메인을 다룰 때는 용어집부터 세운다 (`docs/workflow.md`의 `grill-with-docs` 단계, [`docs/impact-scope.md`](docs/impact-scope.md)). 기존 ADR과 도메인 용어를 존중하고 임의로 동의어를 만들지 않는다 — 코드보다 도메인 모델을 먼저, 그리고 계속 다듬는다는 관점을 그대로 가져왔다.
- **전술적 설계(Tactical Design)**: 실제 코드 구조는 "깊은 모듈과 seam" 규율([`docs/design-discipline.md`](docs/design-discipline.md))로 통제한다. 모듈의 일관성 경계를 seam으로 명시적으로 정하고 그 경계 밖은 건드리지 않는다는 점에서, DDD의 애그리게잇(aggregate) 경계와 같은 역할을 한다.

이 두 층위를 관통하는 원칙은 **에이전트가 판단을 대신 내리지 않고 피드백한다**는 것이다. 기존 패턴이 표준·베스트 프랙티스와 어긋나 보여도 에이전트가 직접 고치지 않고, "차이 + 트레이드오프를 보고 → 사용자가 결정"하는 방향으로 못박았다 ([`docs/impact-scope.md`](docs/impact-scope.md)). DDD의 모델이 도메인 전문가와 개발자 사이의 지속적인 대화(knowledge crunching)로 다듬어지는 것처럼, 이 지침에서도 규칙은 에이전트가 일방적으로 적용하는 게 아니라 사용자와의 피드백 루프를 통해 정제되도록 설계했다.

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
