#!/bin/sh

temp_folder=~/.config/eww/tmp

# sets the PRIMARY_MONITOR_ID environment variable
function exportPrimary(){
    if ! test -f "$temp_folder/primary_screen"; then
        touch $temp_folder/primary_screen
    fi
    # for display id run: 'hyprctl monitors'
    # id of your primary screen: ()
    primary_monitor_id=$(head -1 $temp_folder/primary_screen)

    # all available monitors
    NB_MONITORS=($(hyprctl monitors -j | jq -r '.[] | .id'))
    # check if monitor is available
    if [[ ! " ${NB_MONITORS[*]} " =~ " ${primary_monitor_id} " ]]; then
        primary_monitor_id=0
    fi

    export PRIMARY_MONITOR_ID=$primary_monitor_id
}

# sets the BACKGROUND_IMAGE environment variable
function exportBackground(){
    if ! test -f "$temp_folder/background"; then
        touch $temp_folder/background
    fi
    # load the background variables
    background_image=$(head -1 $temp_folder/background)

    [ -z $background_image ] && background_image="~/.config/hypr/themes/apatheia/wallpapers/Planet.png"

    export BACKGROUND_IMAGE=$background_image
}

exportPrimary
exportBackground

function setVar(){
    checkENVDir $2
    echo $1 > "$temp_folder/$2"
}

function checkENVDir() {
    if ! test -d "$temp_folder"; then
        mkdir $temp_folder
    fi
    if ! test -f "$temp_folder/$1"; then
        touch $temp_folder/$1
    fi
}

doc() {
    echo "Usage:
    set_env [Options]
    Options:
        primary     Sets the primary screen
        background  Sets the image location of the active wallpaper"
}

case $1 in          #function #file param #file name
    primary)		setVar $2 primary_screen	;;
    background)		setVar $2 background        ;;
    help)           doc                         ;;
    *)              doc                         ;;
esac