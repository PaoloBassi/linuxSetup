#!/bin/bash

# mac/ directory and shared (OS-independent) config files from the Linux setup
MAC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHARED_DIR="$(cd "$MAC_DIR/../install_scripts/files" && pwd)"
FILES_DIR="$MAC_DIR/files"

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

# error counter (each install script exits with it, setup.sh sums them up)
error_counter=0

# shared log file across all install scripts of the same run
LOG_FILE="${LOG_FILE:-/tmp/install_script_$(date +%s).log}"
export LOG_FILE

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
        # show output and still log it; keep the command's exit status for check_result
        "$@" 2>&1 | tee -a "$LOG_FILE"
        ( exit "${PIPESTATUS[0]}" )
    else
        "$@" >> "$LOG_FILE" 2>&1
    fi

    check_result "$label"
}

# symlink $1 to $2, replacing any existing file/link (the old file is backed up once)
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "$dst.bak" || { error "Failed to back up $dst"; return; }
    fi
    ln -sfn "$src" "$dst" || error "Failed to link $dst"
}

# make brew available in non-login shells (Apple Silicon prefix)
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
