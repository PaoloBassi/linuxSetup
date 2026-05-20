#!/bin/bash

source install_scripts/declarations.sh

NVIM_VERSION="v0.10.3"
NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCHIVE}"

run_silent "Downloading neovim ${NVIM_VERSION}" curl -LO "$NVIM_URL"
run_silent "Removing previous neovim install" sudo rm -rf /opt/nvim
run_silent "Extracting neovim" sudo tar -C /opt -xzf "$NVIM_ARCHIVE"
run_silent "Linking neovim binary" sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
run_silent "Cleaning archive" rm -f "$NVIM_ARCHIVE"

# Create config directory structure
mkdir -p ~/.config/nvim/lua/core
mkdir -p ~/.config/nvim/lua/plugins

success "Neovim ${NVIM_VERSION} installed"
