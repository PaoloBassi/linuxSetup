#!/bin/bash

source "$(dirname "$0")/declarations.sh"

# neovim and tree-sitter-cli come from the Brewfile
link "$SHARED_DIR/nvim" "$HOME/.config/nvim"

run_silent "Installing neovim plugins" nvim --headless "+Lazy! sync" +qa

exit $error_counter
