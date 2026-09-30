#!/bin/bash

source "$(dirname "$0")/declarations.sh"

[ -d "$HOME/oh-my-tmux" ] || \
    run_silent "Clone tmux powerline" git clone --single-branch https://github.com/gpakosz/.tmux.git "$HOME/oh-my-tmux"
link "$HOME/oh-my-tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
run_silent "Install local config file" cp "$FILES_DIR/tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"

exit $error_counter
