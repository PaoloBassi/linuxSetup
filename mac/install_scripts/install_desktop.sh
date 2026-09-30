#!/bin/bash

source "$(dirname "$0")/declarations.sh"

# SbarLua: lua module used by the sketchybar config (installed in ~/.local/share/sketchybar_lua)
if [ ! -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]; then
    SBARLUA_TMP="$(mktemp -d)"
    run_silent "Installing SbarLua" bash -c \
        "git clone https://github.com/FelixKratz/SbarLua.git '$SBARLUA_TMP' && make -C '$SBARLUA_TMP' install"
    rm -rf "$SBARLUA_TMP"
fi

# sketchybar and borders run as launchd agents, AeroSpace starts itself at login
run_silent "Starting sketchybar" brew services restart sketchybar
run_silent "Starting borders" brew services restart borders
run_silent "Starting AeroSpace" open -a AeroSpace

run_silent "Setting wallpaper" osascript -e \
    "tell application \"System Events\" to tell every desktop to set picture to POSIX file \"$SHARED_DIR/wallpapers/catpuccinWallpaper.jpg\""

mkdir -p "$HOME/Pictures/Screenshots"

exit $error_counter
