#!/bin/bash

source install_scripts/declarations.sh

# Retrieve the apps vector from a file
if [ -n $APP_FILE ]; then
    error "Application file not found. Please create it with the list of applications to install."
    exit 1
fi

run_silent "Updating package list" sudo apt update

info "Installing packages"
for app in $(cat "$APP_FILE"); do
    # if first char is not #, install the app
    [[ "$app" =~ ^#.* ]] && continue
    [[ -z "$app" ]] && continue  # Skip empty lines

    run_silent "Installing ${app}" sudo apt install -y "$app"
done
