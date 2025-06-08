#!/bin/bash

source install_scripts/declarations.sh

ln -s $SCRIPT_DIR/files/gitconfig $HOME/.gitconfig || error "Failed to link .gitconfig"
ln -s $SCRIPT_DIR/files/vimrc $HOME/.vimrc || error "Failed to link .vimrc"
ln -s $SCRIPT_DIR/files/config.rasi $HOME/.config/rofi/config.rasi || error "Failed to link rofi config"
ln -s $SCRIPT_DIR/files/Xmodmap $HOME/.Xmodmap || error "Failed to link Xmodmap"
ln -s $SCRIPT_DIR/files/sakura.conf $HOME/.config/sakura/sakura.conf || error "Failed to link sakura config"

if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
    if [ $? -ne 0 ]; then
        error "Failed to set DISPLAY variable"
    else
        xmodmap $HOME/.Xmodmap || error "Failed to set keyboard layout"
    fi
else
    xmodmap ~/.Xmodmap || error "Failed to set keyboard layout"
fi
