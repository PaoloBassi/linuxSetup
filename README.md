# Linux Setup
Personal startup setup for linux environment.
Clone, fire and forget, everything is configured for you.

# How to use it
- Close the repository in any directory you want
- Then issue the following commands to run the setup script:
```bash
cd linuxSetup
./setup.sh
```

At the end of the script, the powerlevel10k theme asks to be configured. You can quit the procedure and configure it later by issuing the following command:
```bash
p10k configure
```

# What can you expect AFTER
By default, the following packages will be installed:
- curl tmux git silversearcher-ag universal-ctags bat rofi flameshot unzip x11-xserver-utils gpg software-properties-common build-essential make cmake clang cppcheck clang-tidy clangd libglib2.0-dev libgtk-3-dev libvte-2.91-dev
- zsh + oh-my-zsh
- fzf
- glow
- sakura terminal
- 9.1 vim version with the following plugins:
   - airblade/vim-gitgutter
   - editorconfig/editorconfig-vim
   - itchyny/lightline.vim
   - junegunn/fzf
   - junegunn/fzf.vim
   - mattn/emmet-vim
   - scrooloose/nerdtree
   - terryma/vim-multiple-cursors
   - tpope/vim-eunuch
   - tpope/vim-surround
   - tpope/vim-commentary
   - dense-analysis/ale
   - itspriddle/vim-shellcheck
   - dyng/ctrlsf.vim
   - ryanoasis/vim-devicons
   - morhetz/gruvbox
   - fcpg/vim-fahrenheit
   - sheerun/vim-polyglot
   - vim-airline/vim-airline
   - vim-airline/vim-airline-themes
   - octol/vim-cpp-enhanced-highlight
   - thaerkh/vim-workspace
   - easymotion/vim-easymotion
   - ludovicchabant/vim-gutentags
   - preservim/tagbar
   - (commented out) lervag/vimtex', '{ 'tag': 'v2.15' }
- tmux + oh-my-tmux
- Gruvbox and fahrenheit themes for vim + custom script to switch between them
- Configuration files for zsh, tmux, vim, git, and rofi soft linked to your home directory

# TODO
- Vim plugins are not installed even if the script issues the command, so you need to launch it by hand

```bash
vim +PlugInstall +qall
```

# Notes
- The first time you use fzf in vim it asks you to install it. Confirm it
- extensions.sh script contains other packages that I use, but they are not installed by default, since they could lengthen the installation time. Uncomment the lines you want to install and launch it with
```bash
./extensions.sh
```
- The install scripts are separated for convenience. You can comment them out in the main script if you don't want to install them. Exceptions could be made for the install_apps.sh script, because it contains the installation of essential packages. In that case, you can remove apps you don't want to install directly insidethe script.

- The user can change the default vim color appearance by invoking the following commmand
```bash
vimcolors <color>
```

where <color> can be one of the following:
- gruvbox
- fahrenheit
