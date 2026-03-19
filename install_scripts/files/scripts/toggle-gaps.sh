#!/bin/bash

TOGGLE_FILE="$HOME/.toggle-gaps"

if [ -f "$TOGGLE_FILE" ]; then
    rm "$TOGGLE_FILE"
    hyprctl keyword general:gaps_in 5
    hyprctl keyword general:gaps_out 10
    hyprctl keyword decoration:rounding 10
else
    touch "$TOGGLE_FILE"
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword decoration:rounding 0
fi
