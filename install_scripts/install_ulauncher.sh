#!/bin/bash

source install_scripts/declarations.sh

run_silent "Installing ulauncher" bash -c 'sudo add-apt-repository universe -y && sudo add-apt-repository ppa:agornostal/ulauncher -y && sudo apt update && sudo apt install -y ulauncher'
