#!/usr/bin/env bash
set -Eeuo pipefail

git log --color=always --oneline --date=short --pretty=format:'%Cred%h %C(bold blue)%cn%Creset %cd %C(yellow)%d %C(bold white)%s' |
  fzf --ansi --no-multi --preview-window right:50% \
    --preview "git show --oneline --color=always (echo {} | awk '{print \$1}') | delta" |
  awk '{print $1}'
