#!/run/current-system/sw/bin/bash
# Requires: swaymsg, jq, column, dmenu, awk

set -e
set -o pipefail

ID=$(swaymsg -t get_tree \
  | jq -r 'recurse(.nodes[]) | select(.window != -1 and .type == "con") | (.id | tostring) + "|" + .window_properties.class + "|" + .name' \
  | column -t -s"|" \
  | dmenu -i -nb '#000033' -b -l 10 -p 'Switch to:' \
  | awk '{print $1;}')

swaymsg "[con_id=$ID] focus"
