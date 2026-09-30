#!/bin/bash

source "$(dirname "$0")/declarations.sh"

# vim itself comes from the Brewfile (python3 + clipboard already enabled)
link "$SHARED_DIR/vimrc" "$HOME/.vimrc"
link "$SHARED_DIR/plugins.vim" "$HOME/.vim/plugins.vim"
# ~/.vim/plugin is sourced after vimrc: mac-only overrides go there
link "$FILES_DIR/vim/macos.vim" "$HOME/.vim/plugin/macos.vim"

# colorschemes (same as install_scripts/install_themes.sh)
clone_theme() {
    [ -d "$2" ] || run_silent "Installing $1 theme for vim" git clone "$3" "$2"
}
clone_theme gruvbox          "$HOME/.vim/pack/default/start/gruvbox"          https://github.com/morhetz/gruvbox.git
clone_theme gruvbox-material "$HOME/.vim/pack/default/start/gruvbox-material" https://github.com/sainnhe/gruvbox-material
clone_theme catppuccin       "$HOME/.vim/pack/vendor/start/catppuccin"        https://github.com/catppuccin/vim.git

run_silent "Installing vim plugins" vim -es -u "$HOME/.vimrc" -i NONE +PlugInstall +qall

YCM_DIR="$HOME/.vim/plugged/YouCompleteMe"
if [ -d "$YCM_DIR" ]; then
    run_silent "Compiling YouCompleteMe" python3 "$YCM_DIR/install.py" --clangd-completer
else
    error "YouCompleteMe not found, run 'vim +PlugInstall' and then $YCM_DIR/install.py"
fi

exit $error_counter
