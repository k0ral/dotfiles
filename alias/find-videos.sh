#!/usr/bin/env bash

fd \
  --absolute-path \
  --type f \
  --extension mp4 \
  --extension avi \
  --extension webm \
  --extension mkv \
  --extension flv \
  --extension wmv \
  --extension MP4 \
  --extension m4v \
  . \
  "$@"

