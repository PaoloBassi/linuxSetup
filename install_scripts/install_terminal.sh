#!/bin/bash

source install_scripts/declarations.sh

# cursor-fx needs Ghostty >= 1.4: distro package if recent enough, else the ghostty-ubuntu .deb, else snap
ghostty_candidate=$(apt-cache policy ghostty 2>/dev/null | awk '/Candidate:/ {print $2}')
if [ -n "$ghostty_candidate" ] && [ "$ghostty_candidate" != "(none)" ] && dpkg --compare-versions "$ghostty_candidate" ge 1.4; then
    run_silent "Installing ghostty terminal (apt)" sudo apt install -y ghostty
else
    run_silent "Installing ghostty terminal (ghostty-ubuntu .deb, snap fallback)" bash -c \
        'curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh | bash || { sudo apt install -y snapd && sudo snap install ghostty --classic; }'
fi
run_silent "Create Ghostty config directory" mkdir -p ~/.config/ghostty
