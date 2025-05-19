#!/bin/bash

# Ask user for their preferred color scheme
echo "Please select your preferred color scheme:"
echo "1. gruvbox-material"
echo "2. fahrenheit"
read -p "Enter your choice number: " color_choice

if [[ $color_choice -eq 1 ]]; then
    color_scheme="gruvbox-material"
elif [[ $color_choice -eq 2 ]]; then
    color_scheme="fahrenheit"
else
    echo "Invalid choice. Defaulting to gruvbox-material color scheme."
    color_scheme="gruvbox-material"
fi

# search for vim colorscheme in .vimrc and change the color scheme
if grep -q "colorscheme" ~/.vimrc; then
    sed -i "s/colorscheme .*/colorscheme $color_scheme/" ~/.vimrc
else
    echo "colorscheme $color_scheme" >> ~/.vimrc
fi
