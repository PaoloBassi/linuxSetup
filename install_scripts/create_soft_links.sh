#!/bin/bash

source install_scripts/declarations.sh

ln -s $SCRIPT_DIR/files/gitconfig $HOME/.gitconfig || error "Failed to link .gitconfig"
ln -s $SCRIPT_DIR/files/vimrc $HOME/.vimrc || error "Failed to link .vimrc"
ln -s $SCRIPT_DIR/files/sakura.conf $HOME/.config/sakura/sakura.conf || error "Failed to link sakura config"

# Create directories and extract files
mkdir -p $HOME/.config/ulauncher || error "Failed to create ulauncher config directory"
mkdir -p $HOME/.local/share/icons || error "Failed to create icons directory"
mkdir -p $HOME/.themes || error "Failed to create themes directory"

# Download and extract icons
ICONS_URL="https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1641890852/Gruvbox-Dark.zip?response-content-disposition=attachment%3B%2520Gruvbox-Dark.zip&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20250808%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250808T071815Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=7ef0b58a1a082277030466119b34ff72910db8928db8a956eff9b28f69445cdf"

# Download and extract theme
THEME_URL="https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1641887808/Gruvbox-Dark-BL-LB.zip?response-content-disposition=attachment%3B%2520Gruvbox-Dark-BL-LB.zip&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20250808%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250808T081029Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=c5f1174ca7043f1909f0055892ebb6b0f5bb69955e73098aeba9940285336fde"

curl -L $ICONS_URL -o gruvbox-icons.zip || error "Failed to download gruvbox-icons.zip"
unzip -o gruvbox-icons.zip -d $SCRIPT_DIR/.local/share/icons || error "Failed to unzip gruvbox-icons.zip"
rm -rf gruvbox-icons.zip || error "Failed to remove gruvbox-icons.zip"

curl -L $THEME_URL -o gruvbox-theme.zip || error "Failed to download gruvbox-theme.zip"
unzip -o gruvbox-theme.zip -d $SCRIPT_DIR/.themes || error "Failed to unzip gruvbox-themes.zip"
rm -rf gruvbox-themes.zip || error "Failed to remove gruvbox-themes.zip"

tar xf $SCRIPT_DIR/files/ulauncher-config.tar.gz -C $HOME/.config/ulauncher/ || error "Failed to extract ulauncher-config.tar.gz file"

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
