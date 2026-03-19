#!/bin/bash

source install_scripts/declarations.sh

run_silent "Installing hyprland" sudo apt install -y hyprland
run_silent "Installing waybar" sudo apt install -y waybar
run_silent "Installing rofi" sudo apt install -y rofi
run_silent "Installing wl-clipboard" sudo apt install -y wl-clipboard
run_silent "Installing dunst" sudo apt install -y dunst
run_silent "Installing grim" sudo apt install -y grim
run_silent "Installing slurp" sudo apt install -y slurp
run_silent "Installing xdg-desktop-portal-hyprland" sudo apt install -y xdg-desktop-portal-hyprland
run_silent "Installing jq" sudo apt install -y jq
