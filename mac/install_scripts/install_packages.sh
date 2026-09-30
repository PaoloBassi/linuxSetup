#!/bin/bash

source "$(dirname "$0")/declarations.sh"

run_silent "Installing Brewfile packages" brew bundle --file="$MAC_DIR/Brewfile"

exit $error_counter
