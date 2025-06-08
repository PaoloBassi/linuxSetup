#!/bin/bash

source install_scripts/declarations.sh

run_silent "Installing sakura terminal" bash -c 'git clone https://github.com/dabisu/sakura.git sakura && cd sakura && cmake . && make && sudo make install && cd .. && rm -rf sakura'
run_silent "Create Sakura config directory" mkdir -p ~/.config/sakura
