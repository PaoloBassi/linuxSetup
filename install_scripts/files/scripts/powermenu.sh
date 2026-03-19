#!/bin/bash

REBOOT="⭮  Reboot"
SHUTDOWN="⏻  Shutdown"
LOGOUT="⇠  Logout"
SUSPEND="⏾  Suspend"

CHOICE=$(printf "%s\n%s\n%s\n%s" "$REBOOT" "$SHUTDOWN" "$LOGOUT" "$SUSPEND" \
    | rofi -dmenu -p "Power:")

case "$CHOICE" in
    "$REBOOT")   systemctl reboot ;;
    "$SHUTDOWN")  systemctl poweroff ;;
    "$LOGOUT")   hyprctl dispatch exit ;;
    "$SUSPEND")  systemctl suspend ;;
esac
