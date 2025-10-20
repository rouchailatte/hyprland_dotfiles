#!/bin/bash
# BYYB Terminal Theme Switcher
# Controls: Kitty terminal colors ONLY
# Does NOT affect: Desktop theme, Waybar, wallpaper

# Log for debugging
exec 2>/tmp/kitty-theme-switcher.log
set -x

# Show theme selection menu
THEME=$(echo -e "White (Current)\nBlack Dark\nDracula\nNord\nGruvbox Dark\nSolarized Dark\nTokyo Night\nMonokai\nGreen Matrix\nBlue Terminal" | wofi --show dmenu --prompt "Select Kitty Theme")

# Exit if no selection
[[ -z "$THEME" ]] && exit 0

KITTY_CONF="$HOME/.config/kitty/kitty.conf"

# Remove existing color scheme lines
sed -i '/^# THEME:/,/^color15/d' "$KITTY_CONF"
sed -i '/^foreground\|^background\|^selection_foreground\|^selection_background\|^cursor /d' "$KITTY_CONF"
sed -i '/^color[0-9]/d' "$KITTY_CONF"
sed -i '/^active_tab_foreground\|^active_tab_background\|^inactive_tab_foreground\|^inactive_tab_background/d' "$KITTY_CONF"

case "$THEME" in
    "White (Current)")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: White (Current)
foreground #000000
background #ffffff
selection_foreground #ffffff
selection_background #000000
cursor #000000

# Tab bar
active_tab_foreground #ffffff
active_tab_background #000000
inactive_tab_foreground #000000
inactive_tab_background #ffffff

# Black
color0 #000000
color8 #808080
color1 #000000
color9 #000000
color2 #000000
color10 #000000
color3 #000000
color11 #000000
color4 #000000
color12 #000000
color5 #000000
color13 #000000
color6 #000000
color14 #000000
color7 #808080
color15 #000000
EOF
        ;;
    "Black Dark")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Black Dark
foreground #ffffff
background #000000
selection_foreground #000000
selection_background #ffffff
cursor #ffffff

# Tab bar
active_tab_foreground #000000
active_tab_background #ffffff
inactive_tab_foreground #ffffff
inactive_tab_background #000000

# Black & White
color0 #000000
color8 #808080
color1 #ffffff
color9 #ffffff
color2 #ffffff
color10 #ffffff
color3 #ffffff
color11 #ffffff
color4 #ffffff
color12 #ffffff
color5 #ffffff
color13 #ffffff
color6 #ffffff
color14 #ffffff
color7 #ffffff
color15 #ffffff
EOF
        ;;
    "Dracula")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Dracula
foreground #f8f8f2
background #282a36
selection_foreground #ffffff
selection_background #44475a
cursor #f8f8f2

# Tab bar
active_tab_foreground #282a36
active_tab_background #bd93f9
inactive_tab_foreground #f8f8f2
inactive_tab_background #282a36

color0 #000000
color8 #4d4d4d
color1 #ff5555
color9 #ff6e67
color2 #50fa7b
color10 #5af78e
color3 #f1fa8c
color11 #f4f99d
color4 #bd93f9
color12 #caa9fa
color5 #ff79c6
color13 #ff92d0
color6 #8be9fd
color14 #9aedfe
color7 #bfbfbf
color15 #e6e6e6
EOF
        ;;
    "Nord")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Nord
foreground #d8dee9
background #2e3440
selection_foreground #000000
selection_background #fffacd
cursor #d8dee9

# Tab bar
active_tab_foreground #2e3440
active_tab_background #88c0d0
inactive_tab_foreground #d8dee9
inactive_tab_background #2e3440

color0 #3b4252
color8 #4c566a
color1 #bf616a
color9 #bf616a
color2 #a3be8c
color10 #a3be8c
color3 #ebcb8b
color11 #ebcb8b
color4 #81a1c1
color12 #81a1c1
color5 #b48ead
color13 #b48ead
color6 #88c0d0
color14 #8fbcbb
color7 #e5e9f0
color15 #eceff4
EOF
        ;;
    "Gruvbox Dark")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Gruvbox Dark
foreground #ebdbb2
background #282828
selection_foreground #282828
selection_background #ebdbb2
cursor #ebdbb2

# Tab bar
active_tab_foreground #282828
active_tab_background #fabd2f
inactive_tab_foreground #ebdbb2
inactive_tab_background #282828

color0 #282828
color8 #928374
color1 #cc241d
color9 #fb4934
color2 #98971a
color10 #b8bb26
color3 #d79921
color11 #fabd2f
color4 #458588
color12 #83a598
color5 #b16286
color13 #d3869b
color6 #689d6a
color14 #8ec07c
color7 #a89984
color15 #ebdbb2
EOF
        ;;
    "Solarized Dark")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Solarized Dark
foreground #839496
background #002b36
selection_foreground #93a1a1
selection_background #073642
cursor #839496

# Tab bar
active_tab_foreground #002b36
active_tab_background #268bd2
inactive_tab_foreground #839496
inactive_tab_background #002b36

color0 #073642
color8 #002b36
color1 #dc322f
color9 #cb4b16
color2 #859900
color10 #586e75
color3 #b58900
color11 #657b83
color4 #268bd2
color12 #839496
color5 #d33682
color13 #6c71c4
color6 #2aa198
color14 #93a1a1
color7 #eee8d5
color15 #fdf6e3
EOF
        ;;
    "Tokyo Night")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Tokyo Night
foreground #a9b1d6
background #1a1b26
selection_foreground #a9b1d6
selection_background #33467c
cursor #a9b1d6

# Tab bar
active_tab_foreground #1a1b26
active_tab_background #7aa2f7
inactive_tab_foreground #a9b1d6
inactive_tab_background #1a1b26

color0 #15161e
color8 #414868
color1 #f7768e
color9 #f7768e
color2 #9ece6a
color10 #9ece6a
color3 #e0af68
color11 #e0af68
color4 #7aa2f7
color12 #7aa2f7
color5 #bb9af7
color13 #bb9af7
color6 #7dcfff
color14 #7dcfff
color7 #a9b1d6
color15 #c0caf5
EOF
        ;;
    "Monokai")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Monokai
foreground #f8f8f2
background #272822
selection_foreground #000000
selection_background #f8f8f2
cursor #f8f8f0

# Tab bar
active_tab_foreground #272822
active_tab_background #a6e22e
inactive_tab_foreground #f8f8f2
inactive_tab_background #272822

color0 #272822
color8 #75715e
color1 #f92672
color9 #f92672
color2 #a6e22e
color10 #a6e22e
color3 #f4bf75
color11 #f4bf75
color4 #66d9ef
color12 #66d9ef
color5 #ae81ff
color13 #ae81ff
color6 #a1efe4
color14 #a1efe4
color7 #f8f8f2
color15 #f9f8f5
EOF
        ;;
    "Green Matrix")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Green Matrix
foreground #00ff00
background #000000
selection_foreground #000000
selection_background #00ff00
cursor #00ff00

# Tab bar
active_tab_foreground #000000
active_tab_background #00ff00
inactive_tab_foreground #00ff00
inactive_tab_background #000000

color0 #000000
color8 #003300
color1 #00ff00
color9 #00ff00
color2 #00ff00
color10 #00ff00
color3 #00ff00
color11 #00ff00
color4 #00ff00
color12 #00ff00
color5 #00ff00
color13 #00ff00
color6 #00ff00
color14 #00ff00
color7 #00ff00
color15 #00ff00
EOF
        ;;
    "Blue Terminal")
        cat >> "$KITTY_CONF" << 'EOF'
# THEME: Blue Terminal
foreground #00d9ff
background #0a0e27
selection_foreground #0a0e27
selection_background #00d9ff
cursor #00d9ff

# Tab bar
active_tab_foreground #0a0e27
active_tab_background #00d9ff
inactive_tab_foreground #00d9ff
inactive_tab_background #0a0e27

color0 #0a0e27
color8 #1a3a52
color1 #00d9ff
color9 #00d9ff
color2 #00d9ff
color10 #00d9ff
color3 #00d9ff
color11 #00d9ff
color4 #00d9ff
color12 #00d9ff
color5 #00d9ff
color13 #00d9ff
color6 #00d9ff
color14 #00d9ff
color7 #00d9ff
color15 #00d9ff
EOF
        ;;
    *)
        exit 0
        ;;
esac

# Reload all Kitty instances
pkill -SIGUSR1 kitty

# Send notification
notify-send "Kitty Theme Changed" "Applied: $THEME"
