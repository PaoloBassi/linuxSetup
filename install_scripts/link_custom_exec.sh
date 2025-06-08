#!/bin/bash

source install_scripts/declarations.sh

info "Link executable scripts into /usr/local/bin"
pushd /usr/local/bin
for script in $SCRIPT_DIR/files/scripts/*; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script" .sh)
        run_silent "Linking $script_name" sudo ln -s $(realpath $script) $script_name
    fi
done
popd
