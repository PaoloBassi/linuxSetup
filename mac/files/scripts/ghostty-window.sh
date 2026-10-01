#!/bin/bash

# new window in the running Ghostty: `open -na` would start one process per window,
# and cmd-q would then quit only the focused one
if pgrep -xq ghostty; then
    osascript -e 'tell application "Ghostty" to new window' >/dev/null
else
    open -a Ghostty
fi
