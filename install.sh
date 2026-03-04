#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/8] 시스템 패키지 설치"
sudo apt-get update -y
sudo apt-get install -y git curl build-essential

echo "==> [2/8] gh CLI 설치"
if ! command -v gh &>/dev/null; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get update -y
  sudo apt-get install -y gh
  echo "    gh CLI 설치 완료"
else
  echo "    gh CLI 이미 설치됨 (건너뜀)"
fi

echo "==> [3/8] mise 설치"
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
  echo "    mise 설치 완료"
else
  echo "    mise 이미 설치됨 (건너뜀)"
fi

echo "==> [4/8] Node.js v24 설치 (mise)"
eval "$(mise activate bash)" 2>/dev/null || true
mise install node@24
mise use --global node@24
echo "    Node.js $(node --version) 설치 완료"

echo "==> [5/8] uv 설치 (pipx)"
if ! command -v uv &>/dev/null; then
  if ! command -v pipx &>/dev/null; then
    sudo apt-get install -y pipx
    pipx ensurepath
  fi
  pipx install uv
  echo "    uv 설치 완료"
else
  echo "    uv 이미 설치됨 (건너뜀)"
fi

echo "==> [6/8] dotfiles 심링크 생성"
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "    $dst -> $src"
}

link "$DOTFILES_DIR/home/.bashrc"   "$HOME/.bashrc"
link "$DOTFILES_DIR/home/.profile"  "$HOME/.profile"
link "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES_DIR/home/.npmrc"    "$HOME/.npmrc"
link "$DOTFILES_DIR/config/ssh/config" "$HOME/.ssh/config"

echo "==> [7/8] Claude Code 설치"
if ! command -v claude &>/dev/null; then
  # npm-global prefix 설정
  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"
  export PATH="$HOME/.npm-global/bin:$PATH"
  npm install -g @anthropic-ai/claude-code
  echo "    Claude Code 설치 완료"
else
  echo "    Claude Code 이미 설치됨 (건너뜀)"
fi

echo "==> [8/8] 후속 작업 안내"
echo ""
echo "  다음 단계를 수동으로 실행하세요:"
echo ""
echo "  1) GitHub 인증:"
echo "     gh auth login --web --git-protocol ssh"
echo ""
echo "  2) SSH 키 생성 (새 PC인 경우):"
echo "     ssh-keygen -t ed25519 -C 'kkyok7713@naver.com'"
echo "     cat ~/.ssh/id_ed25519.pub  # GitHub에 등록"
echo ""
echo "  3) 셸 재시작 또는:"
echo "     source ~/.bashrc"
echo ""
echo "설치 완료!"
