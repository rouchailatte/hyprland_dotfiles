# Hyprland Dotfiles

This is a backup of your Hyprland desktop environment configuration and essential dotfiles.

## Contents

- `config/` - Configuration files for Hyprland and related applications
  - `hypr/` - Hyprland window manager configuration
  - `kitty/` - Kitty terminal configuration
  - `mako/` - Mako notification daemon configuration
  - `waybar/` - Waybar status bar configuration
  - `wofi/` - Wofi launcher configuration
- `home/` - Home directory dotfiles
  - `.bashrc` - Bash shell configuration
  - `.gitconfig` - Git configuration
- `emacs/` - Emacs configuration
  - `init.el` - Emacs initialization file
- `ssh/` - SSH configuration
  - `config` - SSH client configuration
- `packages-*.txt` - Package lists for different Linux distributions
- `deploy.sh` - Configuration deployment script

## Restoration Instructions

### Quick Setup (Recommended):

1. Clone this repository to the new machine:
   ```bash
   git clone https://github.com/rouchailatte/hyprland_dotfiles.git
   cd hyprland_dotfiles
   ```

2. Run the deployment script to symlink all configurations:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. For Hyprland setup: Log out and select "Hyprland" from your display manager

### What Gets Deployed:

The deployment script will automatically symlink:
- **Bash configuration** → `~/.bashrc`
- **Git configuration** → `~/.gitconfig`
- **SSH configuration** → `~/.ssh/config`
- **Emacs configuration** → `~/.emacs.d/init.el`
- **Hyprland configs** → `~/.config/hypr/`
- **Terminal/UI configs** → `~/.config/kitty/`, `~/.config/waybar/`, etc.

### Manual Restoration

If you prefer manual setup:

1. Install packages based on your distro (see packages-*.txt)
2. Manually symlink or copy individual config files as needed

## Keeping in Sync

To keep multiple machines in sync:
1. Make changes to your configs on any machine
2. Commit and push changes to this repository
3. Pull changes on other machines: `git pull`
4. Re-run the deployment script if needed: `./deploy.sh`

