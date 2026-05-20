#!/bin/bash

source install_scripts/declarations.sh

ln -s $SCRIPT_DIR/files/gitconfig $HOME/.gitconfig || error "Failed to link .gitconfig"
ln -s $SCRIPT_DIR/files/vimrc $HOME/.vimrc || error "Failed to link .vimrc"
ln -s $SCRIPT_DIR/files/nvim $HOME/.config/nvim || error "Failed to link nvim config"
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

# Hyprland config
mkdir -p $HOME/.config/hypr
ln -s $SCRIPT_DIR/files/hypr/hyprland.conf $HOME/.config/hypr/hyprland.conf || error "Failed to link hyprland config"
ln -s $SCRIPT_DIR/files/wallpapers/catpuccinWallpaper.jpg $HOME/.config/hypr/wallpaper.png || error "Failed to link hyprland wallpaper"
ln -s $SCRIPT_DIR/files/hypr/hyprpaper.conf $HOME/.config/hypr/hyprpaper.conf || error "Failed to link hyprpaper config"
ln -s $SCRIPT_DIR/files/hypr/hyprlock.conf $HOME/.config/hypr/hyprlock.conf || error "Failed to link hyprlock config"
ln -s $SCRIPT_DIR/files/hypr/hypridle.conf $HOME/.config/hypr/hypridle.conf || error "Failed to link hypridle config"

# Dunst config
mkdir -p $HOME/.config/dunst
ln -s $SCRIPT_DIR/files/dunst/dunstrc $HOME/.config/dunst/dunstrc || error "Failed to link dunst config"

# Wlogout config
mkdir -p $HOME/.config/wlogout
ln -s $SCRIPT_DIR/files/wlogout/layout $HOME/.config/wlogout/layout || error "Failed to link wlogout layout"
ln -s $SCRIPT_DIR/files/wlogout/style.css $HOME/.config/wlogout/style.css || error "Failed to link wlogout style"

# Waybar config
mkdir -p $HOME/.config/waybar
ln -s $SCRIPT_DIR/files/waybar/config.jsonc $HOME/.config/waybar/config.jsonc || error "Failed to link waybar config"
ln -s $SCRIPT_DIR/files/waybar/style.css $HOME/.config/waybar/style.css || error "Failed to link waybar style"

# Flameshot config
mkdir -p $HOME/.config/flameshot
ln -s $SCRIPT_DIR/files/flameshot.ini $HOME/.config/flameshot/flameshot.ini || error "Failed to link flameshot config"

# Rofi config
mkdir -p $HOME/.config/rofi
ln -s $SCRIPT_DIR/files/config.rasi $HOME/.config/rofi/config.rasi || error "Failed to link rofi config"
ln -s $SCRIPT_DIR/files/catppuccin-mocha.rasi $HOME/.config/rofi/catppuccin-mocha.rasi || error "Failed to link rofi theme"

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
