#!/bin/bash

SUDOERS_FILE="/private/etc/sudoers.d/yabai"
HASH=$(shasum -a 256 $(which yabai) | cut -d " " -f 1)
tmp_file=$(mktemp)
CHANGED=false

while read -r line; do
  SUDOERS_ENTRY="$USER ALL=(root) NOPASSWD: sha256:$HASH $(which yabai) --load-sa"
  if [[ $line == *"sha256:"* ]]; then
    LINE_HASH=$(echo "$line" | cut -d ' ' -f 4 | cut -d ':' -f 2)
    if [[ "$HASH" != "$LINE_HASH" ]]; then
      CHANGED=true
      echo "$line" | sed -e "s/sha256:[[:alnum:]]*/sha256:${HASH}/" >>"$tmp_file"
    else
      echo "$line" >>"$tmp_file"
    fi
  else
    echo "$line" >> "$tmp_file"
  fi
done < "$SUDOERS_FILE"

if [[ "$CHANGED" = true ]]; then
  [ "$UID" -eq 0 ] ||  exec sudo bash "$0" "$@"
  cat "$tmp_file" > "$SUDOERS_FILE"
  echo "Updated yabai sudoers entry."
fi

rm "$tmp_file"
