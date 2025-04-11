#!/bin/bash

# Various packages
sudo apt install -y curl git silversearcher-ag exuberant-ctags bat rofi flameshot

# Tabby Terminal
curl -LO https://github.com/Eugeny/tabby/releases/download/v1.0.223/tabby-1.0.223-linux-x64.deb
sudo dpkg -i tabby-1.0.223-linux-x64.deb
rm -rf tabby-1.0.223-linux-x64.deb

# Install VIM version >= 9.0 (for copilot reason)
sudo add-apt-repository ppa:jonathonf/vim 
sudo apt update
sudo apt install -y vim

# copy all plugins inside the vim folder and install them
mkdir -p ~/.vim/plugin
cp ~/linuxSetup/file/CurtineIncSw.vim ~/.vim/plugin/CurtineIncSw.vim
cp ~/linuxSetup/file/plugins.vim ~/.vim/plugins.vim
vim +PluginInstall +qall

# Gruvbox theme for fzf and rofi
git clone https://github.com/morhetz/gruvbox.git ~/.vim/pack/default/start/gruvbox
git clone https://github.com/bardisty/gruvbox-rofi ~/.config/rofi/themes/gruvbox

# Latex packages (remove # if you want to install)
# sudo apt install -y texlive
# sudo apt install -y zathura
# sudo apt install -y latexmk

# download and install Iosevka font
mkdir -p ~/.local/share/fonts/
pushd ~/.local/share/fonts/
curl -LO https://github.com/be5invis/Iosevka/releases/download/v33.2.0/PkgTTF-Iosevka-33.2.0.zip
curl -LO https://github.com/be5invis/Iosevka/releases/download/v33.2.0/PkgTTF-IosevkaTerm-33.2.0.zip
unzip PkgTTF-Iosevka-33.2.0.zip
unzip PkgTTF-IosevkaTerm-33.2.0.zip
rm -rf PkgTTF-Iosevka-33.2.0.zip
rm -rf PkgTTF-IosevkaTerm-33.2.0.zip
fc-cache -f -v
popd

# install Docker (uncomment if required)

# Add Docker's official GPG key:
#sudo apt-get update
#sudo apt-get install ca-certificates curl
#sudo install -m 0755 -d /etc/apt/keyrings
#sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
#sudo chmod a+r /etc/apt/keyrings/docker.asc
#
## Add the repository to Apt sources:
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
#  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update

#sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ZSH
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ZSH plugins and themes
curl -o - https://raw.githubusercontent.com/kimwz/kimwz-oh-my-zsh-theme/master/install.sh | zsh
#
# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
#
# Soft link for configuration files
ln -s ~/linuxSetup/files/gitconfig ~/.gitconfig
ln -s ~/linuxSetup/files/vimrc ~/.vimrc
ln -s ~/linuxSetup/files/zshrc ~/.zshrc && source ~/.zshrc
ln -s ~/linuxSetup/files/config.rasi ~/.config/rofi/config.rasi
ln -s ~/linuxSetup/files/Xmodmap ~/.Xmodmap && xmodmap ~/.Xmodmap
