#!/bin/bash

# Rename the focused AeroSpace workspace in sketchybar (alt-comma, like hyprland's renameworkspace).
# AeroSpace can't rename workspaces at runtime: the name is a label kept by the bar.
# An empty name restores the workspace number.
NAMES_DIR="$HOME/.local/state/sketchybar/workspace_names"
ws="$(aerospace list-workspaces --focused)"

name="$(osascript -e "text returned of (display dialog \"Rename workspace $ws:\" default answer \"\" with title \"AeroSpace\")")" \
    || exit 0  # dialog cancelled

mkdir -p "$NAMES_DIR"
if [ -n "$name" ]; then
    printf '%s' "$name" > "$NAMES_DIR/$ws"
else
    rm -f "$NAMES_DIR/$ws"
fi

sketchybar --trigger aerospace_windows_change
