#!/usr/bin/env bash
set -Eeuo pipefail

TO="$1"
FILE_PATH="$2"

TMP_DIR="$(mktemp -d)"
TMP_FILE="$TMP_DIR/$(basename "$FILE_PATH")"

ffmpeg \
  -i "$FILE_PATH" \
  -acodec copy \
  -vcodec copy \
  -to "$TO" \
  -avoid_negative_ts make_zero \
  "$TMP_FILE"

mv -i "$TMP_FILE" "$FILE_PATH"
rm -r "$TMP_DIR"
