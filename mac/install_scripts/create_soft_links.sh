#!/bin/bash

source "$(dirname "$0")/declarations.sh"

# shared configs
link "$SHARED_DIR/gitconfig" "$HOME/.gitconfig"
link "$SHARED_DIR/eza_colors.zsh" "$HOME/.config/eza_colors.zsh"
link "$SHARED_DIR/agignore" "$HOME/.agignore"

# bat catppuccin theme
mkdir -p "$HOME/.config/bat/themes"
cp "$SHARED_DIR"/bat/themes/*.tmTheme "$HOME/.config/bat/themes/"
run_silent "Building bat theme cache" bat cache --build

# mac-only configs
link "$FILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
link "$FILES_DIR/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
link "$FILES_DIR/sketchybar" "$HOME/.config/sketchybar"
link "$FILES_DIR/borders/bordersrc" "$HOME/.config/borders/bordersrc"

exit $error_counter
