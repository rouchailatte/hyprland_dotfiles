#!/bin/bash

# Deployment script for dotfiles
# This script creates symlinks from the repository to the home directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting dotfiles deployment...${NC}"
echo "Repository location: $SCRIPT_DIR"
echo ""

# Function to create backup of existing file
backup_if_exists() {
    local target=$1
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing file: $target${NC}"
        mkdir -p "$BACKUP_DIR/$(dirname "$target")"
        cp -r "$target" "$BACKUP_DIR/$target"
        echo -e "${GREEN}Backed up to: $BACKUP_DIR/$target${NC}"
    fi
}

# Function to create symlink
create_symlink() {
    local source=$1
    local target=$2

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Backup existing file if it exists and is not a symlink
    backup_if_exists "$target"

    # Remove existing file/symlink
    rm -rf "$target"

    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked: $target -> $source"
}

echo -e "${GREEN}Deploying home directory configs...${NC}"

# Deploy bashrc
if [ -f "$SCRIPT_DIR/home/.bashrc" ]; then
    create_symlink "$SCRIPT_DIR/home/.bashrc" "$HOME/.bashrc"
fi

# Deploy gitconfig
if [ -f "$SCRIPT_DIR/home/.gitconfig" ]; then
    create_symlink "$SCRIPT_DIR/home/.gitconfig" "$HOME/.gitconfig"
fi

echo ""
echo -e "${GREEN}Deploying SSH config...${NC}"

# Deploy SSH config
if [ -f "$SCRIPT_DIR/ssh/config" ]; then
    create_symlink "$SCRIPT_DIR/ssh/config" "$HOME/.ssh/config"
    # Set correct permissions for SSH config
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/config"
    echo -e "${GREEN}✓${NC} Set SSH config permissions"
fi

echo ""
echo -e "${GREEN}Deploying Emacs config...${NC}"

# Deploy Emacs init.el
if [ -f "$SCRIPT_DIR/emacs/init.el" ]; then
    create_symlink "$SCRIPT_DIR/emacs/init.el" "$HOME/.emacs.d/init.el"
fi

echo ""
echo -e "${GREEN}Deploying Hyprland and application configs...${NC}"

# Deploy config directory items
if [ -d "$SCRIPT_DIR/config" ]; then
    for config_item in "$SCRIPT_DIR/config"/*; do
        if [ -e "$config_item" ]; then
            item_name=$(basename "$config_item")
            create_symlink "$config_item" "$HOME/.config/$item_name"
        fi
    done
fi

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Backups created in: $BACKUP_DIR${NC}"
    echo ""
fi

echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc"
echo "2. For Hyprland: Log out and select Hyprland from your display manager"
echo "3. For Emacs: Restart Emacs to load the new configuration"
echo ""
echo -e "${GREEN}Enjoy your configured environment!${NC}"
