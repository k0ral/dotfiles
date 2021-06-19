#!/usr/bin/env bash
set -Eeuo pipefail

ps -f -u "$(id -u)" | sed 1d | fzf -m | awk '{print $2}'
