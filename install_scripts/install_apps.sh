#!/bin/bash

source install_scripts/declarations.sh

declare -a apps=(curl tmux git silversearcher-ag universal-ctags bat rofi flameshot unzip x11-xserver-utils gpg software-properties-common build-essential make cmake clang cppcheck clang-tidy clangd libglib2.0-dev libgtk-3-dev libvte-2.91-dev)

run_silent "Updating package list" sudo apt update

info "Installing packages"
for app in "${apps[@]}"; do
    run_silent "Installing ${app}" sudo apt install -y "$app"
done
