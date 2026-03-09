#!/bin/bash

source install_scripts/declarations.sh

ln -s $SCRIPT_DIR/files/gitconfig $HOME/.gitconfig || error "Failed to link .gitconfig"
ln -s $SCRIPT_DIR/files/vimrc $HOME/.vimrc || error "Failed to link .vimrc"
ln -s $SCRIPT_DIR/files/sakura.conf $HOME/.config/sakura/sakura.conf || error "Failed to link sakura config"

# Create directories and extract files
mkdir -p $HOME/.local/share/icons || error "Failed to create icons directory"
mkdir -p $HOME/.themes || error "Failed to create themes directory"

tar xf $SCRIPT_DIR/files/gruvbox-icons.tar.gz -C $HOME/.local/share/icons/ || error "Failed to extract cursor tar.gz file"
tar xf $SCRIPT_DIR/files/gruvbox-theme.tar.gz -C $HOME/.themes/ || error "Failed to extract theme tar.gz file"

# eza config
ln -s $SCRIPT_DIR/files/eza_colors.zsh $HOME/.config/eza_colors.zsh || error "Failed to link eza colors config"

# ag ignore file config
ln -s $SCRIPT_DIR/files/agignore $HOME/.agignore || error "Failed to link agignore"

#if [ -z "$DISPLAY" ]; then
#    export DISPLAY=:0
#    if [ $? -ne 0 ]; then
#        error "Failed to set DISPLAY variable"
#    else
#        xmodmap $HOME/.Xmodmap || error "Failed to set keyboard layout"
#    fi
#else
#    xmodmap ~/.Xmodmap || error "Failed to set keyboard layout"
#fi
