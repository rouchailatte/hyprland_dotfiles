#!/bin/bash
# BYYB Font Switcher
# Controls: System-wide font (Waybar + Terminal)
# Does NOT affect: Colors or themes

# Log for debugging
exec 2>/tmp/font-switcher.log
set -x

# Show font selection menu
FONT=$(echo -e "Monospace (Default)\nJetBrains Mono\nFira Code\nSource Code Pro\nRoboto Mono\nUbuntu Mono\nDejaVu Sans Mono\nCourier New" | wofi --show dmenu --prompt "Select Font")

# Exit if no selection
[[ -z "$FONT" ]] && exit 0

case "$FONT" in
    "Monospace (Default)")
        FONT_FAMILY="Monospace"
        ;;
    "JetBrains Mono")
        FONT_FAMILY="JetBrains Mono"
        ;;
    "Fira Code")
        FONT_FAMILY="Fira Code"
        ;;
    "Source Code Pro")
        FONT_FAMILY="Source Code Pro"
        ;;
    "Roboto Mono")
        FONT_FAMILY="Roboto Mono"
        ;;
    "Ubuntu Mono")
        FONT_FAMILY="Ubuntu Mono"
        ;;
    "DejaVu Sans Mono")
        FONT_FAMILY="DejaVu Sans Mono"
        ;;
    "Courier New")
        FONT_FAMILY="Courier New"
        ;;
    *)
        exit 0
        ;;
esac

# Update Waybar CSS
sed -i "s/font-family: \".*\", monospace;/font-family: \"$FONT_FAMILY\", monospace;/" "$HOME/.config/waybar/style.css"

# Update Kitty terminal font
if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
    sed -i "s/^font_family.*/font_family $FONT_FAMILY/" "$HOME/.config/kitty/kitty.conf"
    # Reload kitty
    pkill -SIGUSR1 kitty
fi

# Reload waybar with proper signal
pkill -SIGUSR2 waybar || {
    # If reload fails, restart waybar
    pkill waybar
    sleep 0.5
    waybar > /tmp/waybar-restart.log 2>&1 &
}

# Send notification
notify-send "Font Changed" "Applied: $FONT_FAMILY"
