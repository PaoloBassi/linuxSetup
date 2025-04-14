#!/bin/bash

# various colors
ERROR_COLOR=$(tput setaf 1)
SUCCESS_COLOR=$(tput setaf 2)
INFO_COLOR=$(tput setaf 3)
RESET=$(tput sgr0)

# error counter
error_counter=0

# functions to print errors, success, and info messages
function info() { echo "${INFO_COLOR}${@}${RESET}"; }
function error() { echo "${ERROR_COLOR}${@}${RESET}"; ((error_counter++)); }
function success() { echo "${SUCCESS_COLOR}${@}${RESET}"; }

# function to check the result of the last command
function check_result() {
    if [ $? -ne 0 ]; then
        error "Failed to install ${1}"
    else
        success "${1} installed successfully"
    fi
}

# Various packages
declare -a apps=(curl git silversearcher-ag exuberant-ctags bat rofi flameshot unzip x11-xserver-utils gpg software-properties-common build-essential) 

info "Update package list"
sudo apt update

info "Install packages"
for app in "${apps[@]}"; do
    info "Installing ${app}"
    sudo apt install -y "$app"
    result=$?

    check_result "${app}"
done

# glow for markdown
info "Installing glow"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg || error "Failed to add charm gpg key"
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list || error "Failed to add charm repo"
sudo apt update && sudo apt install glow 

check_result "glow"

# Install VIM version >= 9.0 (for copilot reason)
info "Installing vim >= 9.0"
sudo add-apt-repository -y ppa:jonathonf/vim || error "Failed to add vim ppa" 
sudo apt update 
sudo apt install -y vim

check_result "vim"

# Gruvbox theme for fzf and rofi
info "Installing gruvbox theme for fzf and rofi"
git clone https://github.com/morhetz/gruvbox.git ~/.vim/pack/default/start/gruvbox || error "Failed to clone gruvbox theme for vim"
git clone https://github.com/bardisty/gruvbox-rofi ~/.config/rofi/themes/gruvbox || error "Failed to clone gruvbox theme for rofi"

# Soft link for configuration files
ln -s ~/linuxSetup/files/gitconfig ~/.gitconfig || error "Failed to link .gitconfig"
ln -s ~/linuxSetup/files/vimrc ~/.vimrc || error "Failed to link .vimrc"
ln -s ~/linuxSetup/files/config.rasi ~/.config/rofi/config.rasi || error "Failed to link rofi config"
ln -s ~/linuxSetup/files/Xmodmap ~/.Xmodmap || error "Failed to link Xmodmap"

# if display is not set, set it to :0
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0

    if [ $? -ne 0 ]; then
        error "Failed to set DISPLAY variable"
    else
        xmodmap ~/.Xmodmap || error "Failed to set keyboard layout"
    fi
else
    xmodmap ~/.Xmodmap || error "Failed to set keyboard layout"
fi

# copy all plugins inside the vim folder and install them
mkdir -p ~/.vim/plugin || error "Failed to create vim plugin directory"
cp ~/linuxSetup/files/CurtineIncSw.vim ~/.vim/plugin/CurtineIncSw.vim || error "Failed to copy CurtineIncSw.vim"
cp ~/linuxSetup/files/plugins.vim ~/.vim/plugins.vim || error "Failed to copy plugins.vim"
vim +PluginInstall +qall

check_result "vim plugins"

# ZSH
sudo apt install -y zsh || error "Failed to install zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || error "Failed to install oh-my-zsh"

# ZSH plugins and themes
curl -o - https://raw.githubusercontent.com/kimwz/kimwz-oh-my-zsh-theme/master/install.sh | zsh

check_result "kimwz theme"

# zsh plugins
sudo apt install -y zsh-syntax-highlighting

check_result "zsh-syntax-highlighting"

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || error "Failed to clone fzf"
printf "y\ny\nn\n""" | ~/.fzf/install 2> /dev/null

check_result "fzf"

# set zsh as default shell
sudo chsh -s $(which zsh)

check_result "default shell as zsh"

# install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || error "Failed to clone powerlevel10k theme"

# link zsh configuration post installation
rm -rf ~/.zshrc || error "Failed to remove old .zshrc"
ln -s ~/linuxSetup/files/zshrc ~/.zshrc || error "Failed to link .zshrc"

# check errors
if [ $error_counter -ne 0 ]; then
    error "There were ${error_counter} errors during the installation"
else
    success "All packages installation and configurations setup completed successfully"
fi

# launch zsh
zsh
