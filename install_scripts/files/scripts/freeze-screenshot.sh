#!/bin/bash

# Freeze the screen with hyprpicker and take a screenshot of a selected area
hyprpicker -r -z &
PICKER_PID=$!

sleep 0.2

grim -g "$(slurp)" - | wl-copy

kill $PICKER_PID 2>/dev/null
