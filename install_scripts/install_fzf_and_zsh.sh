#!/bin/bash

source install_scripts/declarations.sh

run_silent "Installing zsh" sudo apt install -y zsh
run_silent "Installing oh-my-zsh" bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
run_silent "Installing zsh-syntax-highlighting" sudo apt install -y zsh-syntax-highlighting

run_silent "Installing fzf" bash -c 'git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && printf "y\ny\nn\n" | ~/.fzf/install'
run_silent "Setting zsh as default shell" sudo chsh -s $(which zsh)
run_silent "Install fzf-tab plugin for zsh" git clone https://github.com/Aloxaf/fzf-tab ~/.oh-my-zsh/plugins/fzf-tab
run_silent "Installing powerlevel10k theme" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

rm -rf ~/.zshrc || error "Failed to remove old .zshrc"
ln -s $SCRIPT_DIR/files/zshrc ~/.zshrc || error "Failed to link .zshrc"
