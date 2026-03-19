#!/bin/bash

STATUS=$(playerctl status 2>/dev/null)

case "$STATUS" in
    Playing)
        ARTIST=$(playerctl metadata artist 2>/dev/null)
        TITLE=$(playerctl metadata title 2>/dev/null)
        echo "♫  $ARTIST - $TITLE"
        ;;
    Paused)
        ARTIST=$(playerctl metadata artist 2>/dev/null)
        TITLE=$(playerctl metadata title 2>/dev/null)
        echo "⏸  $ARTIST - $TITLE"
        ;;
    *)
        echo ""
        ;;
esac
