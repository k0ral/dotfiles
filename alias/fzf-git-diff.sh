#!/usr/bin/env bash
set -Eeuo pipefail

git -c color.status=always status --short --untracked-files=no |
  fzf --ansi --no-multi --preview-window right:70% \
    --bind 'left:preview-up,right:preview-down,page-up:preview-page-up,page-down:preview-page-down' \
    --preview "git diff --color=always (echo {} | awk '{print \$2}') | delta"
