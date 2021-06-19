#!/usr/bin/env bash
set -Eeuo pipefail

git branch --color=always --all --sort=-committerdate |
  grep -v HEAD |
  fzf --ansi --no-multi --preview-window right:70% \
      --preview 'git log -n 50 --color=always --oneline --date=short --pretty="format:%Cred%h%Creset %cd %C(bold blue)%cn%Creset %C(yellow)%d %C(bold white)%s" (echo {} | sed "s/.* //")' |
  sed "s/.* //"
