#!/bin/bash

source install_scripts/declarations.sh

./install_scripts/install_apps.sh
#./install_scripts/install_gnome_tweaks.sh
./install_scripts/install_ulauncher.sh
#./install_scripts/install_remapper.sh
./install_scripts/install_terminal.sh
./install_scripts/install_vim.sh
./install_scripts/install_tmux.sh
./install_scripts/install_themes.sh
./install_scripts/create_soft_links.sh
./install_scripts/install_fzf_and_zsh.sh
./install_scripts/link_custom_exec.sh

echo
if [ $error_counter -ne 0 ]; then
    error "There were ${error_counter} errors during the installation (see log at $LOG_FILE)"
else
    success "All packages installation and configuration completed successfully."
    info "For full command outputs, see the log file at: $LOG_FILE"
fi

echo
zsh

