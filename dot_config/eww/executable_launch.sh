#!/bin/bash

EWW="eww -c $HOME/.config/eww"

## Run eww daemon if not running already
if [[ ! $(pidof eww) ]]; then
    ${EWW} daemon
    sleep 1
fi

source $HOME/.config/hypr/scripts/variables/load_envs;
${EWW} open "sidebar0"