#!/usr/bin/env bash
# 새 환경에서 이 플레이북을 한 번에 적용하기 위한 부트스트랩 스크립트.
# AGENTS.md를 각 에이전트 툴이 읽는 위치에 연결하고, 워크플로우 스킬을 설치한다.
set -euo pipefail

PLAYBOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SRC="$PLAYBOOK_DIR/AGENTS.md"

link_global() {
  local target="$1"
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "skip (already exists, not a symlink): $target"
    return
  fi
  ln -sf "$AGENTS_SRC" "$target"
  echo "linked: $target -> $AGENTS_SRC"
}

echo "== 전역 지침 연결 =="
# 각 툴이 전역 설정으로 읽는 파일에 AGENTS.md를 심링크한다.
# 필요 없는 툴은 주석 처리하거나 지운다.
link_global "$HOME/.claude/CLAUDE.md"
link_global "$HOME/.codex/AGENTS.md"
link_global "$HOME/.gemini/GEMINI.md"

echo
echo "== 워크플로우 스킬 설치 (mattpocock/skills, 다수 에이전트 툴 공통 지원) =="
for skill in grill-me grill-with-docs to-spec to-tickets implement tdd setup-matt-pocock-skills; do
  npx skills add "mattpocock/skills@$skill" -g -y
done

echo
echo "완료. 프로젝트별로는 레포 루트에 AGENTS.md를 두고 docs/project-structure.md 규약을 따르세요."
