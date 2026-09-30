#!/bin/bash

source "$(dirname "$0")/declarations.sh"

# -- keyboard (same repeat speed as hyprland: 200ms delay, 50Hz) ---------------
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
# key repeat instead of accent popup (hjkl in vim)
defaults write -g ApplePressAndHoldEnabled -bool false
# no autocorrect/smart punctuation messing with code
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# -- modifier keys: swap option <-> command on the built-in keyboard ------------
# alt ends up next to the space bar as on Linux (AeroSpace, zsh, tmux, nvim binds unchanged).
# Merged into the existing mapping so remaps made from System Settings (e.g. caps lock) survive.
info "Swapping option and command on the built-in keyboard..."
python3 - <<'EOF'
import json, plistlib, subprocess

KEY = "com.apple.keyboard.modifiermapping.0-0-0"  # vendor-product-0 of the built-in keyboard
SWAP = {0x7000000E2: 0x7000000E3, 0x7000000E3: 0x7000000E2,  # left option <-> left command
        0x7000000E6: 0x7000000E7, 0x7000000E7: 0x7000000E6}  # right option <-> right command
SRC, DST = "HIDKeyboardModifierMappingSrc", "HIDKeyboardModifierMappingDst"

prefs = subprocess.run(["defaults", "-currentHost", "export", "-g", "-"],
                       capture_output=True, check=True).stdout
mapping = [m for m in plistlib.loads(prefs).get(KEY, []) if m[SRC] not in SWAP]
mapping += [{SRC: s, DST: d} for s, d in SWAP.items()]

# persisted per host, applied by macOS at login
value = plistlib.dumps(mapping, fmt=plistlib.FMT_XML).decode()
value = value[value.index("<array>"):value.rindex("</array>") + len("</array>")]
subprocess.run(["defaults", "-currentHost", "write", "-g", KEY, value], check=True)

# apply now too, without waiting for a logout
subprocess.run(["hidutil", "property", "--matching", '{"Built-In":1}',
                "--set", json.dumps({"UserKeyMapping": mapping})],
               stdout=subprocess.DEVNULL, check=True)
EOF
check_result

# -- trackpad (tap to click, as in hyprland) -----------------------------------
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

# -- dock ----------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 40

# -- mission control (recommended by AeroSpace) --------------------------------
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.spaces spans-displays -bool true

# -- menu bar: hidden, sketchybar replaces it ----------------------------------
defaults write -g _HIHideMenuBar -bool true

# -- finder --------------------------------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# -- screenshots ---------------------------------------------------------------
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

for app in Dock Finder SystemUIServer; do
    killall "$app" &>/dev/null
done

success "macOS defaults applied (some need logout to take effect)"

exit $error_counter
