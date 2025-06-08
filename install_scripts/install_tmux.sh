#!/bin/bash

source install_scripts/declarations.sh

# Install tmux with powerline
run_silent "Clone tmux powerline" git clone --single-branch https://github.com/gpakosz/.tmux.git $HOME/oh-my-tmux
run_silent "Create config folder" mkdir -p $HOME/.config/tmux
run_silent "Link ohmytmux config to local one" ln -s $HOME/oh-my-tmux/.tmux.conf $HOME/.config/tmux/tmux.conf
run_silent "Install local config file" cp $SCRIPT_DIR/files/tmux.conf.local $HOME/.config/tmux/tmux.conf.local
