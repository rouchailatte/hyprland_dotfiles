#!/bin/bash
# BYYB Desktop Theme Switcher
# Controls: Hyprland desktop, Waybar top bar, wallpaper
# Does NOT affect: Terminal colors (use TERM button), fonts (use FONT button)

# Log for debugging
exec 2>/tmp/theme-switcher.log
set -x

THEME_DIR="$HOME/.config/hypr/themes"
mkdir -p "$THEME_DIR"

# Show theme selection menu
THEME=$(echo -e "White (Current)\nBlack Dark\nBlue Terminal\nGreen Matrix\nRed Alert\nPurple Cyberpunk" | wofi --show dmenu --prompt "Select Theme")

# Exit if no selection
[[ -z "$THEME" ]] && exit 0

# Read current font from existing style.css to preserve it
CURRENT_FONT=$(grep -oP 'font-family: "\K[^"]+' "$HOME/.config/waybar/style.css" | head -1)
# Default to Monospace if not found
CURRENT_FONT="${CURRENT_FONT:-Monospace}"

case "$THEME" in
    "White (Current)")
        BG_COLOR="#ffffff"
        FG_COLOR="#000000"
        BORDER_COLOR="#000000"
        INACTIVE_BORDER="#808080"
        BAR_BG="#ffffff"
        BAR_FG="#000000"
        ;;
    "Black Dark")
        BG_COLOR="#000000"
        FG_COLOR="#ffffff"
        BORDER_COLOR="#ffffff"
        INACTIVE_BORDER="#808080"
        BAR_BG="#000000"
        BAR_FG="#ffffff"
        ;;
    "Blue Terminal")
        BG_COLOR="#0a0e27"
        FG_COLOR="#00d9ff"
        BORDER_COLOR="#00d9ff"
        INACTIVE_BORDER="#1a3a52"
        BAR_BG="#0a0e27"
        BAR_FG="#00d9ff"
        ;;
    "Green Matrix")
        BG_COLOR="#000000"
        FG_COLOR="#00ff00"
        BORDER_COLOR="#00ff00"
        INACTIVE_BORDER="#003300"
        BAR_BG="#000000"
        BAR_FG="#00ff00"
        ;;
    "Red Alert")
        BG_COLOR="#1a0000"
        FG_COLOR="#ff0000"
        BORDER_COLOR="#ff0000"
        INACTIVE_BORDER="#330000"
        BAR_BG="#1a0000"
        BAR_FG="#ff0000"
        ;;
    "Purple Cyberpunk")
        BG_COLOR="#0d0221"
        FG_COLOR="#ff006e"
        BORDER_COLOR="#ff006e"
        INACTIVE_BORDER="#3a0066"
        BAR_BG="#0d0221"
        BAR_FG="#ff006e"
        ;;
    *)
        exit 0
        ;;
esac

# Update Hyprland colors
hyprctl keyword general:col.active_border "rgb(${BORDER_COLOR#\#})"
hyprctl keyword general:col.inactive_border "rgb(${INACTIVE_BORDER#\#})"

# Update wallpaper
pkill swaybg
swaybg -c "$BG_COLOR" &

# Update Waybar style
cat > "$HOME/.config/waybar/style.css" << EOF
/* BYYB Terminal Core - Waybar Style */
/* Theme: $THEME */

* {
    font-family: "$CURRENT_FONT", monospace;
    font-size: 12px;
    font-weight: normal;
    min-height: 0;
    padding: 0;
    margin: 0;
}

window#waybar {
    background-color: $BAR_BG;
    color: $BAR_FG;
    border-bottom: 1px solid $BAR_FG;
    padding: 0;
    margin: 0;
}

/* Workspaces */
#workspaces {
    background-color: $BAR_BG;
    margin: 0;
    padding: 0;
}

#workspaces button {
    padding: 0 8px;
    background-color: $BAR_BG;
    color: $BAR_FG;
    border: none;
    border-right: 1px solid $BAR_FG;
    border-radius: 0;
    min-width: 30px;
}

#workspaces button.active {
    background-color: $BAR_FG;
    color: $BAR_BG;
}

#workspaces button:hover {
    background-color: ${INACTIVE_BORDER};
}

/* Window title */
#window {
    background-color: $BAR_BG;
    color: $BAR_FG;
    padding: 0 10px;
    border-right: 1px solid $BAR_FG;
    font-weight: normal;
}

/* Clock */
#clock {
    background-color: $BAR_BG;
    color: $BAR_FG;
    padding: 0 10px;
    border-left: 1px solid $BAR_FG;
    border-right: 1px solid $BAR_FG;
    font-weight: bold;
}

/* Right modules */
#cpu,
#memory,
#disk,
#temperature,
#pulseaudio,
#network,
#battery,
#tray,
#custom-theme,
#custom-font,
#custom-kitty-theme {
    background-color: $BAR_BG;
    color: $BAR_FG;
    padding: 0 10px;
    border-left: 1px solid $BAR_FG;
}

#battery.charging {
    background-color: $BAR_BG;
    color: $BAR_FG;
}

#battery.warning {
    background-color: $BAR_BG;
    color: $BAR_FG;
}

#battery.critical {
    background-color: $BAR_FG;
    color: $BAR_BG;
}

#pulseaudio.muted {
    background-color: ${INACTIVE_BORDER};
    color: $BAR_FG;
}

/* Tray */
#tray {
    background-color: $BAR_BG;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: $BAR_FG;
}

/* Tooltips */
tooltip {
    background-color: $BAR_FG;
    color: $BAR_BG;
    border: 1px solid $BAR_FG;
    border-radius: 0;
}

tooltip label {
    color: $BAR_BG;
}

/* System monitoring modules */
#cpu,
#memory,
#disk {
    font-weight: normal;
}

#temperature.critical {
    background-color: $BAR_FG;
    color: $BAR_BG;
    font-weight: bold;
}

#network:hover {
    background-color: ${INACTIVE_BORDER};
}

/* Custom modules */
#custom-theme:hover,
#custom-font:hover,
#custom-kitty-theme:hover {
    background-color: ${INACTIVE_BORDER};
}
EOF

# Reload waybar with proper signal
pkill -SIGUSR2 waybar || {
    # If reload fails, restart waybar
    pkill waybar
    sleep 0.5
    waybar > /tmp/waybar-restart.log 2>&1 &
}

# Send notification
notify-send "Theme Changed" "Applied: $THEME"
