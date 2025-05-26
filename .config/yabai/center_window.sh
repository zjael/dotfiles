#!/usr/bin/env sh

if [ -z "$1" ]; then
  log "Error: No window ID provided."
  echo "Usage: $0 <window_id>"
  exit 1
fi

YABAI_WINDOW_ID=$1
window=$(yabai -m query --windows --window "$YABAI_WINDOW_ID" 2>/dev/null)
display=$(yabai -m query --displays --window "$YABAI_WINDOW_ID" 2>/dev/null)

if [ -z "$window" ] || [ -z "$display" ]; then
  echo "Failed to retrieve window or display information."
  exit 1
fi

coords=$(jq \
  --argjson window "$window" \
  --argjson display "$display" \
  -nr '(($display.frame | .x + .w / 2) - ($window.frame.w / 2) | tostring)
        + ":"
        + (($display.frame | .y + .h / 2) - ($window.frame.h / 2) | tostring)')

if [ $? -ne 0 ]; then
  echo "Failed to calculate coordinates."
  exit 1
fi

yabai -m window "$YABAI_WINDOW_ID" --move "abs:$coords" 2>/dev/null

if [ $? -ne 0 ]; then
  echo "Failed to move the window."
  exit 1
fi