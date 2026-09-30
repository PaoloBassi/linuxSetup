#!/bin/bash

# gaps on: config is a symlink to the repo; gaps off: local copy with all gaps zeroed
CONFIG="$HOME/.config/aerospace/aerospace.toml"
REPO_CONFIG="$(dirname "$(realpath "$0")")/../aerospace/aerospace.toml"

if [ -L "$CONFIG" ]; then
    # outer.top keeps room for sketchybar
    sed -E -e '/^\[gaps\]/,/^\[/ s/= [0-9]+$/= 0/' -e 's/^(outer\.top +)= .*$/\1= [{ monitor.built-in = 2 }, 40]/' \
        "$REPO_CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"
else
    ln -sfn "$(realpath "$REPO_CONFIG")" "$CONFIG"
fi

aerospace reload-config
