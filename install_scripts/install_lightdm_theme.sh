#!/bin/bash

source install_scripts/declarations.sh

THEME_NAME="Catppuccin-Mocha-LightDM"
THEME_DIR="/usr/share/themes/${THEME_NAME}"
FILES_DIR="$SCRIPT_DIR/files/lightdm"
WALLPAPER_SRC="$SCRIPT_DIR/files/wallpapers/catpuccinWallpaper.jpg"
WALLPAPER_DEST="/usr/share/lightdm/catpuccinWallpaper.jpg"

# ── Copy wallpaper to system path (LightDM runs as its own user) ─────────────

run_silent "Copying wallpaper to /usr/share/lightdm/" \
    sudo cp "${WALLPAPER_SRC}" "${WALLPAPER_DEST}"

# ── Install GTK3 theme ────────────────────────────────────────────────────────

run_silent "Creating theme directory" sudo mkdir -p "${THEME_DIR}/gtk-3.0"

run_silent "Copying GTK3 CSS" \
    sudo cp "${FILES_DIR}/gtk-3.0/gtk.css" "${THEME_DIR}/gtk-3.0/gtk.css"

# Minimal index.theme so GTK recognises it
run_silent "Writing theme index" sudo bash -c "cat > '${THEME_DIR}/index.theme' <<'EOF'
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=${THEME_NAME}
Comment=Catppuccin Mocha theme for LightDM GTK Greeter

[X-GNOME-Metatheme]
GtkTheme=${THEME_NAME}
MetacityTheme=Catppuccin-Mocha-LightDM
IconTheme=Papirus-Dark
EOF"

# ── Apply greeter configuration ───────────────────────────────────────────────

run_silent "Applying greeter config" \
    sudo cp "${FILES_DIR}/lightdm-gtk-greeter.conf" /etc/lightdm/lightdm-gtk-greeter.conf

# ── Optional: install Papirus-Dark icons if missing ───────────────────────────

if [ ! -d /usr/share/icons/Papirus-Dark ]; then
    run_silent "Installing Papirus-Dark icons" sudo apt install -y papirus-icon-theme
fi

echo ""
success "LightDM Catppuccin Mocha theme applied."
info "Restart LightDM or reboot to see the changes:"
info "  sudo systemctl restart lightdm"
