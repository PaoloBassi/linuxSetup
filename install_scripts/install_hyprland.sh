#!/bin/bash

source install_scripts/declarations.sh

run_silent "Installing hyprland" sudo apt install -y hyprland
run_silent "Installing waybar" sudo apt install -y waybar
run_silent "Installing rofi" sudo apt install -y rofi
run_silent "Installing wl-clipboard" sudo apt install -y wl-clipboard
run_silent "Installing dunst" sudo apt install -y dunst
run_silent "Installing flameshot" sudo apt install -y flameshot
run_silent "Installing grim" sudo apt install -y grim
run_silent "Installing xdg-desktop-portal-hyprland" sudo apt install -y xdg-desktop-portal-hyprland
run_silent "Installing jq" sudo apt install -y jq
run_silent "Installing hyprpaper" sudo apt install -y hyprpaper
run_silent "Installing hyprpicker" sudo apt install -y hyprpicker
run_silent "Installing playerctl" sudo apt install -y playerctl
run_silent "Installing network-manager" sudo apt install -y network-manager
run_silent "Installing hyprlock" sudo apt install -y hyprlock
run_silent "Installing hypridle" sudo apt install -y hypridle
run_silent "Installing cliphist" sudo apt install -y cliphist
run_silent "Installing thunar" sudo apt install -y thunar
run_silent "Installing wlogout" sudo apt install -y wlogout
run_silent "Installing slurp" sudo apt install -y slurp
run_silent "Installing brightnessctl" sudo apt install -y brightnessctl
run_silent "Installing wireplumber" sudo apt install -y wireplumber

bash install_scripts/install_lightdm_theme.sh "$@"
