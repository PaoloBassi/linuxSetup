#!/bin/bash

source "$(dirname "$0")/declarations.sh"

if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools (confirm the GUI prompt, then re-run setup.sh)"
    xcode-select --install
    exit 1
fi

if ! command -v brew &>/dev/null; then
    run_silent "Installing Homebrew" \
        env NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    success "Homebrew already installed"
fi

run_silent "Updating Homebrew" brew update

exit $error_counter
