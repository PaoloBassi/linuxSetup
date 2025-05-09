# Linux Setup
Personal startup setup for linux environment

# How to use it
- cd linuxSetup
- ./setup.sh

# What can you expect AFTER
- Ag, fzf, ctags, bat, rofi, flameshot
- Vim >= 9.0
- Gruvbox theme for vim and rofi
- Zsh, vim and git configuration files are now soft linked into your home directory.
- Zsh with oh-my-zsh, loaded at startup

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

- The user can change the default vim color appearance by invoking the following commmand
```bash
vimcolors <color>
```

where <color> can be one of the following:
- gruvbox
- fahrenheit
