#!/bin/bash

source install_scripts/declarations.sh

# Prerequisite for vim
run_silent "Installing vim prerequisite" bash -c 'sudo apt install -y libncurses5-dev libx11-dev libxt-dev libxpm-dev libgtk-3-dev python3-dev git'
info "Install vim in Programs"
pushd ~
run_silent "Clone last vim version" git clone https://github.com/vim/vim.git && cd vim && make distclean

mkdir build

run_silent "Generate makefile" ./configure --enable-gui=gtk3 \
    --prefix=$(realpath ./build)

run_silent "Compile vim" make -j$(nproc)
run_silent "Install vim" sudo make install
run_silent "Soft link to /usr/local/bin" sudo ln -s $(realpath ./build/bin/vim) /usr/local/bin/vim

popd

mkdir -p ~/.vim/plugin || error "Failed to create vim plugin directory"
ln -s $SCRIPT_DIR/files/plugins.vim ~/.vim/plugins.vim || error "Failed to link plugins.vim"
# run_silent "Installing vim plugins" vim +PluginInstall +qall
