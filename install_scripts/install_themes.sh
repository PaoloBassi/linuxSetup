#!/bin/bash

source install_scripts/declarations.sh

run_silent "Installing gruvbox theme for vim" git clone https://github.com/morhetz/gruvbox.git $HOME/.vim/pack/default/start/gruvbox
run_silent "Installing gruvbox-material theme for vim" git clone https://github.com/sainnhe/gruvbox-material $HOME/.vim/pack/default/start/gruvbox-material
