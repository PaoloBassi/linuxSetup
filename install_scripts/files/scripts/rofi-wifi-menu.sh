#!/bin/bash

TOGGLE="⏻  Toggle WiFi"

WIFI_STATE=$(nmcli radio wifi)

NETWORKS=$(nmcli -f SSID,SECURITY,SIGNAL dev wifi list 2>/dev/null \
    | tail -n +2 \
    | awk '{printf "%-30s %-10s %s%%\n", $1, $2, $NF}' \
    | sed '/^--/d')

CHOICE=$(printf "%s\n%s" "$TOGGLE" "$NETWORKS" | fuzzel --dmenu -p "󰤨  WiFi: ")

if [[ -z "$CHOICE" ]]; then
    exit 0
fi

if [[ "$CHOICE" = "$TOGGLE" ]]; then
    if [[ "$WIFI_STATE" = "enabled" ]]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
    exit 0
fi

SSID=$(echo "$CHOICE" | awk '{print $1}')

if [[ -z "$SSID" ]]; then
    exit 0
fi

nmcli dev wifi connect "$SSID" 2>/dev/null && exit 0

PASS=$(zenity --password --title="WiFi: $SSID" 2>/dev/null)
[[ -n "$PASS" ]] && nmcli dev wifi connect "$SSID" password "$PASS"
