# TODO – mac setup

## Decisions to confirm
- [x] JankyBorders (mauve→blue border like Hyprland): keep?
- [x] Hidden native menu bar (`_HIHideMenuBar` in `macos_defaults.sh`): keep?
- [x] Extra binds `alt-e` (split orientation), `alt-tab` (prev workspace), `alt-shift-r` (reload): ok?
- [x] Brewfile GUI apps: only VS Code enabled
- [ ] Not ported: toggle-float all, pseudo, wifi menu, exit session

## Run
```bash
cd ~/linuxSetup/mac && ./setup.sh -v
```
- [x] Check error count at the end, read the log in `/tmp/install_script_*.log`
- [x] Accessibility permission for AeroSpace (System Settings > Privacy & Security)
- [x] Open Raycast once and complete the onboarding
- [x] Logout/login

- [x] Option <-> Command swapped on the built-in keyboard (alt under the thumbs)

## Verify
**Shell**
- [x] p10k prompt, fzf-tab on `<tab>`, syntax highlighting, `cd` = zoxide
- [x] `ls`/`la` (eza colors), `cat` (bat Catppuccin), `ff`, `rg`, `ga`, `lf`, `lg`
- [x] `echo test | c` → clipboard via pbcopy

**tmux**
- [x] Catppuccin theme, status bar at the top, `prefix+e` extrakto

**Vim / Neovim**
- [~] `vim`: skipped for now (YCM compiled, not verified)
- [x] `nvim`: lazy synced, LSP clangd (`:Mason`), treesitter, `<F2>` Claude Code
- [x] `vimcolors` changes the theme

**AeroSpace**
- [x] `alt-enter` Ghostty, `alt-hjkl` focus, `alt-shift-hjkl` move, `alt-1..0` workspaces
- [x] `alt-g` toggle gaps (then check that `git status` stays clean)
- [x] `alt-s` screenshot → file in `~/Pictures/Screenshots` + clipboard
- [x] `alt-r` / `alt-c` Raycast (launcher / clipboard)
- [x] `alt-ctrl-l` locks (needs "require password immediately")
- [x] `alt-*` combos don't break the characters you use when typing (US-Intl layout)

**SketchyBar** (FelixKratz lua setup, Mocha)
- [x] `brew bundle` for SF Pro / SF Mono / SF Symbols (sudo): icons render, no boxes
- [x] Accessibility permission for sketchybar, then click the app name: app menus replace the workspaces (click again to go back)
- [x] Workspaces: only occupied + focused, focused with red number and double border, app icons, click switches
- [x] `alt-,` renames the focused workspace (dialog; empty name = back to the number)
- [x] Volume: click = popup with slider + output devices, scroll changes volume
- [x] Battery: click = time remaining
- [x] Bluetooth: icon grey/white/blue (off/on/connected), click = power switch + paired devices, right click = settings
- [x] Nothing hidden behind the notch

**Ghostty**
- [x] IosevkaTerm font, Catppuccin theme, Option works as Alt (zsh vi-mode `kj`)

**macOS defaults**
- [ ] Fast key repeat (hjkl held down), Dock autohide, Finder shows hidden files

## Afterwards
- [x] Commit `mac/`
- [x] Update the main README with a pointer to `mac/README.md`
