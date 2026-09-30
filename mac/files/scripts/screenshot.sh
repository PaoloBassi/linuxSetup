#!/bin/bash

# region screenshot saved to ~/Pictures/Screenshots and copied to clipboard
file="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
mkdir -p "$(dirname "$file")"
screencapture -i "$file" || exit 1
[ -f "$file" ] || exit 0  # selection cancelled
osascript -e "set the clipboard to (read (POSIX file \"$file\") as «class PNGf»)"
