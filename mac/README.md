# macOS Setup
Personal startup setup for macOS (Apple Silicon), mirroring the Linux one.

# How to use it
```bash
cd linuxSetup/mac
./setup.sh          # add -v for verbose output
```
If the Xcode Command Line Tools are missing, the script triggers their installer and exits: re-run it once they're installed.

Manual steps after the script:
- grant Accessibility permission to AeroSpace (System Settings > Privacy & Security > Accessibility)
- open Raycast once and complete the onboarding
- grant Accessibility to `sketchybar` too (app menus in the bar: click the front app name)
- open NotificationNanny, grant it Accessibility, then run `open -a NotificationNanny` again for its settings: top right with a vertical offset that clears sketchybar, and launch at login
- allow AeroSpace to control Ghostty when asked on the first `alt-enter` (new windows open in the running instance)
- grant Full Disk Access to the real sketchybar binary (`realpath $(which sketchybar)`, again after each `brew upgrade` of it: ad-hoc signed), then `brew services restart sketchybar`: the bell widget counts the notifications. Allow sketchybar to control System Events on the first click of the bell
- require the password immediately after sleep, so `alt-ctrl-l` really locks: `sysadminctl -screenLock immediate -password -`
- log out and back in, so keyboard/Dock/Mission Control defaults are applied
- `p10k configure` if you want to reconfigure the prompt

# Linux → macOS mapping
| Linux                     | macOS                                  |
|---------------------------|----------------------------------------|
| apt + apps.txt            | Homebrew + `Brewfile`                  |
| Hyprland                  | AeroSpace (`ALT` as mod, same binds)   |
| Hyprland borders          | JankyBorders (`borders`)               |
| Waybar                    | SketchyBar (FelixKratz lua, Mocha)     |
| fuzzel / rofi / cliphist  | Raycast                                |
| Sakura                    | Ghostty                                |
| grim + slurp              | `screencapture` (`screenshot` script)  |
| hyprlock                  | `pmset displaysleepnow`                |
| Vim compiled from source  | Homebrew vim                           |
| fzf from git              | Homebrew fzf                           |

# Shared vs mac-only files
Shared with Linux (symlinked from `../install_scripts/files`): `nvim/`, `vimrc`, `plugins.vim`, `gitconfig`, `p10k.zsh`, `eza_colors.zsh`, `agignore`, bat theme, wallpaper.

Mac-only (`files/`): `zshrc`, `tmux.conf.local`, `ghostty/`, `aerospace/`, `sketchybar/`, `borders/`, `vim/macos.vim` (clipboard override), `scripts/`.

# AeroSpace keybindings
| Key                        | Action                                  |
|----------------------------|-----------------------------------------|
| `alt-enter`                | Ghostty (new window, same instance)     |
| `alt-r`                    | Raycast                                 |
| `alt-c`                    | Raycast clipboard history               |
| `alt-b`                    | Finder                                  |
| `alt-q`                    | close window                            |
| `alt-v`                    | toggle floating                         |
| `alt-f`                    | fullscreen                              |
| `alt-e`                    | toggle split orientation                |
| `alt-g`                    | toggle gaps                             |
| `alt-,`                    | rename workspace (sketchybar label)     |
| `alt-h/j/k/l`, arrows      | focus                                   |
| `alt-shift-h/j/k/l`        | move window                             |
| `alt-ctrl-arrows`          | resize                                  |
| `alt-1..0`                 | workspace 1..10                         |
| `alt-shift-1..0`           | move window to workspace                |
| `alt-tab`                  | previous workspace                      |
| `alt-s` / `alt-shift-s`    | screenshot region (file+clip / clip)    |
| `alt-ctrl-l`               | lock                                    |
| `alt-shift-r`              | reload AeroSpace + SketchyBar           |

# Notes
- Optional GUI apps are commented out at the bottom of the `Brewfile`
- SketchyBar is [FelixKratz/dotfiles@0619040](https://github.com/FelixKratz/dotfiles/tree/0619040a8eebbf9896c5ce4fc9d312270426ed8f)'s lua config (SbarLua) in Catppuccin Mocha: yabai spaces ported to AeroSpace (only occupied + focused workspaces, `alt-,` names in `~/.local/state/sketchybar/workspace_names`), widgets limited to battery, volume, a bluetooth widget (blueutil) and a bell with the number of notifications still in Notification Center (click opens it); no cpu/wifi/media. `helpers/app_icons.lua` matches sketchybar-app-font v3.0.5
- `vimcolors` works as on Linux (BSD `sed` variant)
- Ghostty maps Option as Alt, so zsh vi-mode, tmux and nvim see `alt` as on Linux
- Option and Command are swapped on the built-in keyboard (`macos_defaults.sh`): `alt` sits next to the space bar as on Linux, Command moves one key out. Revert from System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys
- `§` (left of `1`) types `` ` `` like the key left of `Z`, for italian accents on US-Intl. Applied at login by `~/Library/LaunchAgents/com.linuxsetup.keymap.plist` (global hidutil mapping, so an external ISO keyboard gets it too); remove that file to revert
- Notification banners are nudged below sketchybar by [NotificationNanny](https://github.com/chessper53/NotificationNanny) (macOS has no offset setting). Ad-hoc signed: its cask strips the quarantine, and Accessibility must be granted again after every update
- Clicking the clock in sketchybar opens Calendar
- Ghostty keeps `window-decoration = auto` (the titlebar is hidden by `macos-titlebar-style`): with `none` the window has no close button and AeroSpace's `alt-q` can't close it
