#!/bin/bash

PAUSED=$(dunstctl is-paused 2>/dev/null)
COUNT=$(dunstctl count waiting 2>/dev/null)

if [ "$PAUSED" = "false" ]; then
    echo '{"text": " ", "tooltip": "Notifications enabled", "class": "enabled"}'
else
    if [ "${COUNT:-0}" -gt 0 ]; then
        echo "{\"text\": \"  $COUNT\", \"tooltip\": \"$COUNT notification(s) waiting\", \"class\": \"waiting\"}"
    else
        echo '{"text": " ", "tooltip": "Notifications paused", "class": "paused"}'
    fi
fi
