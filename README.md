# dotfiles

개발 환경 설정 파일 및 자동 설치 스크립트

## 포함 항목

| 파일 | 설명 |
|------|------|
| `home/.bashrc` | 쉘 설정 (aliases, env vars, mise 활성화) |
| `home/.profile` | PATH 설정 (npm-global, mise, local/bin) |
| `home/.gitconfig` | git 사용자 설정 |
| `home/.npmrc` | npm prefix 설정 |
| `config/ssh/config` | SSH 설정 (개인키 제외) |

## 설치 도구

- git
- [gh CLI](https://cli.github.com/)
- [mise](https://mise.jdx.dev/) + Node.js v24
- [uv](https://docs.astral.sh/uv/) (Python 패키지 매니저)
- [Claude Code CLI](https://github.com/anthropics/claude-code)

## 새 PC 셋업

### SSH 키가 있는 경우
```bash
git clone git@github.com:wh92lee/dotfiles.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

### SSH 키 없이 처음 시작하는 경우
```bash
git clone https://github.com/wh92lee/dotfiles.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

설치 후 안내에 따라 SSH 키 생성 및 GitHub 인증을 완료하세요.

## 보안 주의사항

다음 파일은 절대 커밋하지 않습니다:
- `~/.ssh/id_*` — 개인 SSH 키
- `~/.claude/.credentials.json` — API 키
- `~/.config/gh/` — gh 인증 토큰
