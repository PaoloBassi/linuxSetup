#!/bin/bash

source install_scripts/declarations.sh

# zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# git-delta
DELTA_VER=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep -Po '"tag_name": "v\K[^"]+')
run_silent "Installing git-delta ${DELTA_VER}" bash -c "
    curl -fsSL 'https://github.com/dandavison/delta/releases/download/v${DELTA_VER}/git-delta_${DELTA_VER}_amd64.deb' -o /tmp/git-delta.deb &&
    sudo dpkg -i /tmp/git-delta.deb &&
    rm /tmp/git-delta.deb
"

