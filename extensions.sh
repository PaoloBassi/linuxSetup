#!/bin/bash

# Latex packages (remove # if you want to install)
# sudo apt install -y texlive
# sudo apt install -y zathura
# sudo apt install -y latexmk
#
# Tabby Terminal
curl -LO https://github.com/Eugeny/tabby/releases/download/v1.0.223/tabby-1.0.223-linux-x64.deb
sudo dpkg -i tabby-1.0.223-linux-x64.deb
rm -rf tabby-1.0.223-linux-x64.deb
#
# download and install Iosevka font
mkdir -p ~/.local/share/fonts/
pushd ~/.local/share/fonts/
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IosevkaTerm.zip
unzip IosevkaTerm.zip
rm -rf IosevkaTerm.zip
fc-cache -f -v
popd
#
# install Docker (uncomment if required)

# Add Docker's official GPG key:
#sudo apt-get update
#sudo apt-get install ca-certificates curl
#sudo install -m 0755 -d /etc/apt/keyrings
#sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
#sudo chmod a+r /etc/apt/keyrings/docker.asc
#
## Add the repository to Apt sources:
#echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
#  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#sudo apt-get update

#sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
