#!/usr/bin/env bash
# Ember installer for Arch Linux + Hyprland 0.56 (Lua config).
# Installs the packages, Tela icons and the Bibata cursor, then copies the dotfiles.
# Anything it replaces is backed up to ~/.config/ember-backup-<date>/ first.
# Run it from inside a Hyprland session (gsettings needs your desktop's D-Bus).
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

packages=(
    hyprland kitty quickshell qt6-svg fuzzel mako hyprlock hypridle hyprpolkitagent
    thunar gvfs tumbler mousepad neovim firefox btop fastfetch
    pipewire pipewire-pulse wireplumber pavucontrol
    ttf-jetbrains-mono-nerd inter-font adw-gtk-theme dconf
    grim slurp wl-clipboard imagemagick curl
)

echo ":: Installing packages"
sudo pacman -S --needed "${packages[@]}"

echo ":: Tela icons (orange) and the Bibata Modern Amber cursor"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL https://github.com/vinceliuice/Tela-icon-theme/archive/refs/heads/master.tar.gz | tar xz -C "$tmp"
"$tmp/Tela-icon-theme-master/install.sh" orange
mkdir -p "$HOME/.local/share/icons"
curl -fsSL https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Amber.tar.xz \
    | tar xJ -C "$HOME/.local/share/icons"

echo ":: Copying dotfiles"
backup="$HOME/.config/ember-backup-$(date +%Y%m%d-%H%M%S)"
cd "$here/dotfiles"
find . -type f | while read -r f; do
    rel="${f#./}"
    dest="$HOME/$rel"
    if [ -e "$dest" ]; then
        mkdir -p "$backup/$(dirname "$rel")"
        cp -a "$dest" "$backup/$rel"
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$f" "$dest"
done
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/hypr/hyprlock.conf"
chmod +x "$HOME/.local/bin/powermenu"
[ -d "$backup" ] && echo "   old files saved in $backup"

echo ":: Painting the wallpaper"
mkdir -p "$HOME/Pictures"
if [ ! -f "$HOME/Pictures/ember.png" ]; then
    magick -size 480x270 xc:'#141210' \
        -fill '#d97757' -draw 'circle 380,215 380,290' \
        -fill '#8fae8b' -draw 'circle 85,50 85,105' \
        -blur 0x55 -resize 1920x1080! -attenuate 0.06 +noise Gaussian \
        "$HOME/Pictures/ember.png"
fi

echo ":: Desktop settings"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
gsettings set org.gnome.desktop.interface icon-theme Tela-orange-dark
gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Amber
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'Inter 11'
gsettings set org.xfce.mousepad.preferences.view color-scheme ember

# helper apps pulled in as dependencies that nobody launches by hand
mkdir -p "$HOME/.local/share/applications"
for app in avahi-discover bssh bvnc xfce4-about thunar-settings thunar-bulk-rename qv4l2 qvidcap; do
    src="/usr/share/applications/$app.desktop"
    if [ -f "$src" ]; then
        cp "$src" "$HOME/.local/share/applications/"
        echo "NoDisplay=true" >> "$HOME/.local/share/applications/$app.desktop"
    fi
done

systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service

echo
echo "Done. Log out and back in to start Ember. Super + / shows every keybind."
