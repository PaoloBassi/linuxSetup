#!/bin/bash

source install_scripts/declarations.sh

# official APT repository (amd64 and arm64), also used on WSL
run_silent "Adding yazi APT repository" bash -c "
    curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null &&
    echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null &&
    sudo apt update
"
run_silent "Installing yazi and preview tools" sudo apt install -y yazi file jq poppler-utils fd-find
run_silent "Installing 7-Zip" bash -c "sudo apt install -y 7zip || sudo apt install -y p7zip-full"

# Debian and Ubuntu ship fd as fdfind
mkdir -p "$HOME/.local/bin"
run_silent "Linking fd" ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
