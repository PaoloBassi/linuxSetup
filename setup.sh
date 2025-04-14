#!/bin/bash

# Various packages
sudo apt install -y curl git silversearcher-ag exuberant-ctags bat rofi flameshot unzip x11-xserver-utils

# glow for markdown
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install glow

# Install VIM version >= 9.0 (for copilot reason)
sudo add-apt-repository ppa:jonathonf/vim 
sudo apt update
sudo apt install -y vim

# Gruvbox theme for fzf and rofi
git clone https://github.com/morhetz/gruvbox.git ~/.vim/pack/default/start/gruvbox
git clone https://github.com/bardisty/gruvbox-rofi ~/.config/rofi/themes/gruvbox

# Soft link for configuration files
ln -s ~/linuxSetup/files/gitconfig ~/.gitconfig
ln -s ~/linuxSetup/files/vimrc ~/.vimrc
ln -s ~/linuxSetup/files/config.rasi ~/.config/rofi/config.rasi
ln -s ~/linuxSetup/files/Xmodmap ~/.Xmodmap && xmodmap ~/.Xmodmap

# copy all plugins inside the vim folder and install them
mkdir -p ~/.vim/plugin
cp ~/linuxSetup/files/CurtineIncSw.vim ~/.vim/plugin/CurtineIncSw.vim
cp ~/linuxSetup/files/plugins.vim ~/.vim/plugins.vim
vim +PluginInstall +qall

# ZSH
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# ZSH plugins and themes
curl -o - https://raw.githubusercontent.com/kimwz/kimwz-oh-my-zsh-theme/master/install.sh | zsh

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
printf "y\ny\nn\n""" | ~/.fzf/install 2> /dev/null

# set zsh as default shell
sudo chsh -s $(which zsh)

# link zsh configuration post installation
rm -rf ~/.zshrc
ln -s ~/linuxSetup/files/zshrc ~/.zshrc

# launch zsh
zsh
