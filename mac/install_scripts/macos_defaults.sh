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

# -- key remaps on the built-in keyboard ----------------------------------------
# option <-> command: alt ends up next to the space bar as on Linux (AeroSpace, zsh, tmux, nvim
# binds unchanged). Merged into the existing mapping so remaps made from System Settings
# (e.g. caps lock) survive.
# § (left of 1) -> ` (key left of Z): easier italian accents on US-Intl.
info "Remapping keys on the built-in keyboard..."
python3 - <<'EOF'
import json, os, plistlib, subprocess

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

# the modifier mapping above only takes modifiers: § -> ` goes through hidutil. Set globally:
# after a reboot a per-service (--matching) UserKeyMapping is ignored for non-modifier keys,
# and macOS owns the per-service one anyway (it writes the modifier mapping there at login)
SECTION, GRAVE = 0x700000064, 0x700000035  # non-US backslash (§) -> grave accent (`)
hidutil = ["/usr/bin/hidutil", "property",
           "--set", json.dumps({"UserKeyMapping": [{SRC: SECTION, DST: GRAVE}]})]

# apply now, and at every login through a LaunchAgent (hidutil mappings don't survive a reboot)
subprocess.run(hidutil, stdout=subprocess.DEVNULL, check=True)
agent = os.path.expanduser("~/Library/LaunchAgents/com.linuxsetup.keymap.plist")
os.makedirs(os.path.dirname(agent), exist_ok=True)
with open(agent, "wb") as f:
    plistlib.dump({"Label": "com.linuxsetup.keymap", "ProgramArguments": hidutil,
                   "RunAtLoad": True}, f)
EOF
check_result

# -- notifications (NotificationNanny) -----------------------------------------
# banners land on sketchybar at the top right: NotificationNanny nudges them down. Its menu bar
# icon would sit in the hidden menu bar, so hide it: `open -a NotificationNanny` while it's
# running opens its settings (position/offset are per display, launch at login)
defaults write com.notificationnanny.app hideMenuBarIcon -bool true

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
