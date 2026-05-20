#!/bin/bash

source install_scripts/declarations.sh

NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_ARCHIVE}"

mkdir -p "$HOME/.local"

run_silent "Downloading neovim ${NVIM_VERSION}" curl -L -o "$NVIM_ARCHIVE" "$NVIM_URL"
run_silent "Removing previous neovim install" rm -rf "$HOME/.local/nvim"
run_silent "Extracting neovim" tar -C "$HOME/.local" -xzf "$NVIM_ARCHIVE"
run_silent "Linking neovim binary" ln -sf "$HOME/.local/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"
run_silent "Cleaning archive" rm -f "$NVIM_ARCHIVE"

# tree-sitter CLI is required by nvim-treesitter to compile parsers
run_silent "Configuring npm prefix to ~/.local" npm config set prefix "$HOME/.local"
run_silent "Installing tree-sitter-cli" npm install -g tree-sitter-cli

success "Neovim ${NVIM_VERSION} installed at $HOME/.local/bin/nvim"
