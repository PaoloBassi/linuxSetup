#!/bin/bash

source "$(dirname "$0")/declarations.sh"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    run_silent "Installing oh-my-zsh" bash -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc'
fi

[ -d "$HOME/.oh-my-zsh/plugins/fzf-tab" ] || \
    run_silent "Install fzf-tab plugin for zsh" git clone https://github.com/Aloxaf/fzf-tab "$HOME/.oh-my-zsh/plugins/fzf-tab"
[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || \
    run_silent "Installing powerlevel10k theme" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

run_silent "Change p10k theme to catppuccin" cp "$SHARED_DIR/p10k.zsh" "$HOME/.p10k.zsh"

# zsh is already the default shell on macOS
[ "$SHELL" = "/bin/zsh" ] || run_silent "Setting zsh as default shell" chsh -s /bin/zsh

rm -f "$HOME/.zshrc"
link "$FILES_DIR/zshrc" "$HOME/.zshrc"

exit $error_counter
