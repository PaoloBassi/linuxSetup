#!/bin/bash

source install_scripts/declarations.sh

# official installer, puts the binary in /usr/local/bin (asks for sudo)
run_silent "Installing starship prompt" bash -c "curl -fsSL https://starship.rs/install.sh | sh -s -- -y"
