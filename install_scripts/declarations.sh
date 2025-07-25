#!/bin/bash

# Get the current script directory path
SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

# verbose flag
VERBOSE=0

# check for verbose flag
for arg in "$@"; do
    if [[ $arg == "-v" || $arg == "--verbose" ]]; then
        VERBOSE=1
    fi
done

# various colors
ERROR_COLOR=$(tput setaf 1)
SUCCESS_COLOR=$(tput setaf 2)
INFO_COLOR=$(tput setaf 3)
RESET=$(tput sgr0)

# symbols
TICK="✔"
CROSS="✘"

# error counter
error_counter=0

# temp file for logging
LOG_FILE="/tmp/install_script_$(date +%s).log"

# file containing the list of applications to install
APP_FILE="install_scripts/files/apps.txt"

# functions to print errors, success, and info messages
function info() { echo -e "${INFO_COLOR}${@}${RESET}"; }
function error() { echo -e "${ERROR_COLOR}${CROSS} ${@}${RESET}"; ((error_counter++)); }
function success() { echo -e "${SUCCESS_COLOR}${TICK} ${@}${RESET}"; }

# function to check the result of the last command
function check_result() {
    if [ $? -ne 0 ]; then
        error " Failed"
    else
        success " Success"
    fi
}

# wrapper for silent execution with log redirection
run_silent() {
    local label="$1"
    shift
    info "$label..."

    if [ $VERBOSE -eq 1 ]; then
        "$@"
    else
        "$@" >> "$LOG_FILE" 2>&1
    fi

    check_result "$label"
}
