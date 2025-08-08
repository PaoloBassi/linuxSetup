#!/bin/bash

source install_scripts/declarations.sh

run_silent "Clone keyd repo" git clone https://github.com/rvaiya/keyd
pushd keyd
run_silent "Compile keyd sources" make && sudo make install
run_silent "enable keyd systemd service" sudo systemctl enable --now keyd
popd

run_silent "Copy default settings into keyd config folder" sudo cp $SCRIPT_DIR/files/default.conf /etc/keyd/
