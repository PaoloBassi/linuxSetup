#!/bin/bash

source install_scripts/declarations.sh

while true; do
    echo ""
    echo "==================================================="
    echo "Welcome to configuration script: press one of the option to expand the menu, or q to quit."
    echo "1. Applications"
    echo "2. Terminal"
    echo "3. Vim"
    echo "4. Tmux"
    echo "5. Themes"
    echo "6. Configuration files installation"
    echo "7. fzf and zsh"
    echo "8. Custom executable files"
    echo "9. Setup script extensions"
    echo "[q/Q]. Quit"
    echo "==================================================="
    echo ""

    read -p "Please enter your choice: " user_input
    if [[ "$user_input" == "q" || "$user_input" == "Q" ]]; then
        echo "Arrivederci!"
        exit 0
    elif [[ "$user_input" == "1" ]]; then
        while true; do
            echo ""
            echo "###### Applications configuration menu:"
            echo "1. List applications to be installed"
            echo "2. Add application"
            echo "3. Skip/enable application"
            echo "4. Remove application"
            echo "5. Skip all"
            echo "6. Enable all"
            echo "7. Remove ALL applications"
            echo "8. Return to main menu"
            echo ""

            read -p "Choose an option: " app_input

            if [[ "$app_input" == "1" ]]; then
                echo "Applications to be installed:"
                for app in $(cat "$APP_FILE"); do
                    [[ -z "$app" ]] && continue  # Skip empty lines

                    if [[ "$app" =~ ^#.* ]]; then
                        echo "$app [skipped]"
                    else
                        echo $app
                    fi
                done
            elif [[ "$app_input" == "2" ]]; then
                read -p "Enter the application name to add: " app_name
                if [[ -n "$app_name" ]]; then
                    echo "$app_name" >> $APP_FILE
                    success "Application '$app_name' added successfully."
                else
                    error "Application name cannot be empty."
                fi
            elif [[ "$app_input" == "3" ]]; then
                read -p "Enter the application name to skip/enable: " app_name
                if [[ -n "$app_name" ]]; then
                    if ! grep -q ".*$app_name" $APP_FILE; then
                        error "Application '$app_name' does not exist in the app list."
                    # if the app is not skipped, skip it
                    elif ! grep -q "^#$app_name" $APP_FILE; then
                        sed -i "s|^$app_name|#$app_name|" $APP_FILE
                        success "Application '$app_name' skipped successfully."
                    # if the app is skipped, enable it
                    elif grep -q "^#$app_name" $APP_FILE; then
                        sed -i "s|^#$app_name|$app_name|" $APP_FILE
                        success "Application '$app_name' enabled successfully."
                    fi
                else
                    error "Application name cannot be empty."
                fi
            elif [[ "$app_input" == "4" ]]; then
                read -p "Enter the application name to remove: " app_name
                if [[ -n "$app_name" ]]; then
                    sed -i "/^$app_name$/d" $APP_FILE 
                    sed -i "/^#$app_name$/d" $APP_FILE
                    success "Application '$app_name' removed successfully."
                else
                    error "Application name cannot be empty."
                fi
            elif [[ "$app_input" == "5" ]]; then
                sed -i "/^#/! s/^/#/" $APP_FILE
                success "All applications skipped successfully."
            elif [[ "$app_input" == "6" ]]; then
                sed -i "s|^#||" $APP_FILE
                success "All applications enabled successfully."
            elif [[ "$app_input" == "7" ]]; then
                read -p "Are you sure you want to remove ALL applications? It cannot be undone (y/n): " confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    > $APP_FILE
                    success "All applications removed successfully."
                fi
            elif [[ "$app_input" == "8" ]]; then
                echo "Returning to main menu..."
                break
            else
                error "Invalid option. Please try again."
            fi
        done

    elif [[ "$user_input" == "2" ]]; then
        while true; do
            echo ""
            echo "##### Choose which terminal to install:"
            echo "1. Sakura"
            echo "2. None"
            echo "3. Return to main menu"
            echo ""

            read -p "Choose an option: " terminal_input

            TERMINAL_FILE="./install_scripts/install_terminal.sh"

            if [[ "$terminal_input" == "1" ]]; then
                success "Sakura terminal will be installed."
                # if there are # characters before the install_terminal.sh line in setup.sh, remove them
                if grep -q "^[[:space:]]*#$TERMINAL_FILE" setup.sh; then
                    sed -i "s|^[[:space:]]*#$TERMINAL_FILE|$TERMINAL_FILE|" setup.sh
                fi
            elif [[ "$terminal_input" == "2" ]]; then
                success "No terminal will be installed."
                # if there are no # characters before the install_terminal.sh line in setup.sh, add them
                if ! grep -q "^[[:space:]]*#$TERMINAL_FILE" setup.sh; then
                    sed -i "s|^[[:space:]]*$TERMINAL_FILE|#$TERMINAL_FILE|" setup.sh
                fi
            elif [[ "$terminal_input" == "3" ]]; then
                echo "Returning to main menu..."
                break
            else
                error "Invalid option. Please try again."
            fi
        done
    elif [[ "$user_input" == "3" ]]; then
        while true; do
            echo ""
            echo "##### Choose whether to install vim:"
            echo "1. Install vim"
            echo "2. Do not install vim"
            echo "3. Return to main menu"
            echo ""

            read -p "Choose an option: " vim_input

            VIM_FILE="./install_scripts/install_vim.sh"

            if [[ "$vim_input" == "1" ]]; then
                success "Vim will be installed."
                # if there are # characters before the install_vim.sh line in setup.sh, remove them
                if grep -q "^[[:space:]]*#$VIM_FILE" setup.sh; then
                    sed -i "s|^[[:space:]]*#$VIM_FILE|$VIM_FILE|" setup.sh
                fi
            elif [[ "$vim_input" == "2" ]]; then
                success "Vim will not be installed."
                # if there are no # characters before the install_vim.sh line in setup.sh, add them
                if ! grep -q "^[[:space:]]*#$VIM_FILE" setup.sh; then
                    sed -i "s|^[[:space:]]*$VIM_FILE|#$VIM_FILE|" setup.sh
                fi
            elif [[ "$vim_input" == "3" ]]; then
                echo "Returning to main menu..."
                break
            else
                error "Invalid option. Please try again."
            fi
        done
#    elif [[ "$user_input" == "4" ]]; then
#    elif [[ "$user_input" == "5" ]]; then
#    elif [[ "$user_input" == "6" ]]; then
#    elif [[ "$user_input" == "7" ]]; then
#    elif [[ "$user_input" == "8" ]]; then
#    elif [[ "$user_input" == "9" ]]; then

    else
        error "Invalid option. Please try again."
    fi
done
