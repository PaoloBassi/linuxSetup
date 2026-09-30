#!/bin/bash

source "$(dirname "$0")/declarations.sh"

# ~/.local/bin instead of /usr/local/bin: no sudo, already in PATH via zshrc
info "Link executable scripts into ~/.local/bin"
mkdir -p "$HOME/.local/bin"
for script in "$FILES_DIR"/scripts/*.sh; do
    [ -f "$script" ] || continue
    chmod +x "$script"
    link "$script" "$HOME/.local/bin/$(basename "$script" .sh)"
done

exit $error_counter
