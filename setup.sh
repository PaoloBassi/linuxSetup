#!/bin/bash

# Get the current script directory path
SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

# verbose flag
VERBOSE=0

# check for verbose flag
for arg in "$@"; do
    if [[ $arg == "-v" || $arg == "--verbose" ]]; then
        VERBOSE=1
    fi
done

# various colors
ERROR_COLOR=$(tput setaf 1)
SUCCESS_COLOR=$(tput setaf 2)
INFO_COLOR=$(tput setaf 3)
RESET=$(tput sgr0)

# symbols
TICK="✔"
CROSS="✘"

# error counter
error_counter=0

# temp file for logging
LOG_FILE="/tmp/install_script_$(date +%s).log"

# functions to print errors, success, and info messages
function info() { echo -e "${INFO_COLOR}${@}${RESET}"; }
function error() { echo -e "${ERROR_COLOR}${CROSS} ${@}${RESET}"; ((error_counter++)); }
function success() { echo -e "${SUCCESS_COLOR}${TICK} ${@}${RESET}"; }

# function to check the result of the last command
function check_result() {
    if [ $? -ne 0 ]; then
        error " Failed"
    else
        success " Success"
    fi
}

# wrapper for silent execution with log redirection
run_silent() {
    local label="$1"
    shift
    info "$label..."

    if [ $VERBOSE -eq 1 ]; then
        "$@"
    else
        "$@" >> "$LOG_FILE" 2>&1
    fi

    check_result "$label"
}

# Various packages
declare -a apps=(curl git silversearcher-ag universal-ctags bat rofi flameshot unzip x11-xserver-utils gpg software-properties-common build-essential cmake clang cppcheck clang-tidy clangd libglib2.0-dev libgtk-3-dev libvte-2.91-dev)

run_silent "Updating package list" sudo apt update

info "Installing packages"
for app in "${apps[@]}"; do
    run_silent "Installing ${app}" sudo apt install -y "$app"
done

run_silent "Installing sakura terminal" bash -c 'git clone https://github.com/dabisu/sakura.git sakura && cd sakura && cmake . && make && sudo make install && cd .. && rm -rf sakura'
run_silent "Create Sakura config directory" mkdir -p ~/.config/sakura

run_silent "Installing glow" bash -c 'sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg && echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null && sudo apt update && sudo apt install -y glow'

# Prerequisite for vim
run_silent "Installing vim prerequisite" bash -c 'sudo apt install -y libncurses5-dev libx11-dev libxt-dev libxpm-dev libgtk-3-dev python3-dev git'
info "Install vim in Programs"
pushd ~
run_silent "Clone last vim version" git clone https://github.com/vim/vim.git && cd vim && make distclean

mkdir build

run_silent "Generate makefile" ./configure --enable-gui=gtk3 \
    --prefix=$(realpath ./build)

run_silent "Compile vim" make -j$(nproc) 
run_silent "Install vim" sudo make install
run_silent "Soft link to /usr/local/bin" sudo ln -s $(realpath ./build/bin/vim) /usr/local/bin/vim

popd

run_silent "Installing gruvbox theme for vim" git clone https://github.com/morhetz/gruvbox.git ~/.vim/pack/default/start/gruvbox
run_silent "Installing gruvbox-material theme for vim" git clone https://github.com/sainnhe/gruvbox-material ~/.vim/pack/default/start/gruvbox-material
run_silent "Installing gruvbox theme for rofi" git clone https://github.com/bardisty/gruvbox-rofi ~/.config/rofi/themes/gruvbox

ln -s $SCRIPT_DIR/files/gitconfig ~/.gitconfig || error "Failed to link .gitconfig"
ln -s $SCRIPT_DIR/files/vimrc ~/.vimrc || error "Failed to link .vimrc"
ln -s $SCRIPT_DIR/files/config.rasi ~/.config/rofi/config.rasi || error "Failed to link rofi config"
ln -s $SCRIPT_DIR/files/Xmodmap ~/.Xmodmap || error "Failed to link Xmodmap"
ln -s $SCRIPT_DIR/files/sakura.conf ~/.config/sakura/sakura.conf || error "Failed to link sakura config"

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

mkdir -p ~/.vim/plugin || error "Failed to create vim plugin directory"
cp $SCRIPT_DIR/files/CurtineIncSw.vim ~/.vim/plugin/CurtineIncSw.vim || error "Failed to copy CurtineIncSw.vim"
cp $SCRIPT_DIR/files/plugins.vim ~/.vim/plugins.vim || error "Failed to copy plugins.vim"
# run_silent "Installing vim plugins" vim +PluginInstall +qall

run_silent "Installing zsh" sudo apt install -y zsh
run_silent "Installing oh-my-zsh" bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
run_silent "Installing zsh-syntax-highlighting" sudo apt install -y zsh-syntax-highlighting

run_silent "Installing fzf" bash -c 'git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && printf "y\ny\nn\n" | ~/.fzf/install'
run_silent "Setting zsh as default shell" sudo chsh -s $(which zsh)
run_silent "Installing powerlevel10k theme" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

rm -rf ~/.zshrc || error "Failed to remove old .zshrc"
ln -s $SCRIPT_DIR/files/zshrc ~/.zshrc || error "Failed to link .zshrc"

info "Link executable scripts into /usr/local/bin"
pushd /usr/local/bin
for script in $SCRIPT_DIR/files/scripts/*; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script" .sh)
        run_silent "Linking $script_name" sudo ln -s $(realpath $script) $script_name
    fi
done
popd

echo
if [ $error_counter -ne 0 ]; then
    error "There were ${error_counter} errors during the installation (see log at $LOG_FILE)"
else
    success "All packages installation and configuration completed successfully."
    info "For full command outputs, see the log file at: $LOG_FILE"
fi

echo
zsh

