#!/usr/bin/env sh

echo "Launched handle_window.sh"

YABAI_WINDOW_ID=$1

if [ -z "$YABAI_WINDOW_ID" ]; then
  echo "Usage: $0 <window_id>"
  exit 1
fi

floating_windows=$(yabai -m query --windows --space "$space_id" | jq '[.[] | select(.["is-floating"] == true and .["is-hidden"] == false and .["is-minimized"] == false)] | length')
window=$(yabai -m query --windows --window "$YABAI_WINDOW_ID" 2>/dev/null)
display=$(yabai -m query --displays --window "$YABAI_WINDOW_ID" 2>/dev/null)
space_id=$(echo "$window" | jq -r .space)

if [ -z "$window" ] || [ -z "$display" ]; then
  echo "Failed to retrieve window or display information."
  exit 1
fi

floating=$(echo "$window" | jq -er '.["is-floating"]')
resizable=$(echo "$window" | jq -er '.["can-resize"]')

echo "Space: $space_id, Floating: $floating, Resizable: $resizable, Floating windows: $floating_windows"

if [ "$floating" == true ] && [ "$floating_windows" -eq 1 ]; then
  echo "Centering window $YABAI_WINDOW_ID"
  /bin/bash "${HOME}/.dotfiles/.config/yabai/center_window.sh" "$YABAI_WINDOW_ID"
fi