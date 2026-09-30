#!/bin/bash

cd "$(dirname "$0")" || exit 1
source install_scripts/declarations.sh

# ask for sudo once and keep it alive until the script ends
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

run_step() {
    "$@"
    error_counter=$((error_counter + $?))
}

run_step ./install_scripts/install_homebrew.sh "$@"
run_step ./install_scripts/install_packages.sh "$@"
run_step ./install_scripts/install_zsh.sh "$@"
run_step ./install_scripts/install_tmux.sh "$@"
run_step ./install_scripts/install_vim.sh "$@"
run_step ./install_scripts/install_neovim.sh "$@"
run_step ./install_scripts/create_soft_links.sh "$@"
run_step ./install_scripts/link_custom_exec.sh "$@"
run_step ./install_scripts/install_desktop.sh "$@"
run_step ./install_scripts/macos_defaults.sh "$@"

echo
if [ $error_counter -ne 0 ]; then
    error "There were ${error_counter} errors during the installation (see log at $LOG_FILE)"
else
    success "All packages installation and configuration completed successfully."
    info "For full command outputs, see the log file at: $LOG_FILE"
fi

echo
info "Manual steps left:"
info "  - grant Accessibility permission to AeroSpace (System Settings > Privacy & Security)"
info "  - open Raycast once and complete its onboarding"
info "  - log out and back in to apply keyboard/Dock/Mission Control defaults"

echo
exec zsh
