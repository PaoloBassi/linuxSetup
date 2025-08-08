#!/bin/bash

source install_scripts/declarations.sh

# Set your desired timezone for gnome tweaks and other applications
run_silent echo "tzdata tzdata/Areas select Europe" | sudo debconf-set-selections
run_silent echo "tzdata tzdata/Zones/Europe select Rome" | sudo debconf-set-selections
run_silent sudo DEBIAN_FRONTEND=noninteractive apt install -y gnome-tweaks

run_silent sudo apt install -y gnome-shell-extensions

