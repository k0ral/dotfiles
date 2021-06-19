#!/usr/bin/env bash
set -Eeuo pipefail

git tag --color=always --sort=-committerdate |
  grep -v HEAD |
  fzf --ansi --no-multi --preview-window right:50% \
      --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" (echo {} | sed "s/.* //")' |
  sed "s/.* //"
