#!/bin/bash

TOGGLE="⏻  Toggle WiFi"

# Get current wifi state
WIFI_STATE=$(nmcli radio wifi)

# List available networks
NETWORKS=$(nmcli -f SSID,SECURITY,SIGNAL dev wifi list 2>/dev/null \
    | tail -n +2 \
    | awk '{printf "%-30s %-10s %s%%\n", $1, $2, $NF}' \
    | sed '/^--/d')

CHOICE=$(printf "%s\n%s" "$TOGGLE" "$NETWORKS" | rofi -dmenu -p "WiFi:")

if [ -z "$CHOICE" ]; then
    exit 0
fi

if [ "$CHOICE" = "$TOGGLE" ]; then
    if [ "$WIFI_STATE" = "enabled" ]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
    exit 0
fi

SSID=$(echo "$CHOICE" | awk '{print $1}')

if [ -z "$SSID" ]; then
    exit 0
fi

# Try connecting (works if network is saved)
nmcli dev wifi connect "$SSID" 2>/dev/null && exit 0

# Ask for password if not saved
PASS=$(rofi -dmenu -p "Password for $SSID:" -password)
[ -n "$PASS" ] && nmcli dev wifi connect "$SSID" password "$PASS"
