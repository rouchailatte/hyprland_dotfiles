# Hyprland Dotfiles

This is a backup of your Hyprland desktop environment configuration.

## Contents

- `config/` - Configuration files for Hyprland and related applications
- `scripts/` - Custom scripts and utilities
- `packages-*.txt` - Package lists for different Linux distributions
- `install.sh` - Automated installation script
- `deploy.sh` - Configuration deployment script

## Restoration Instructions

### On Machine B (Fresh Install):

1. Clone or copy this directory to the new machine
2. Run the installation script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```
3. Log out and select "Hyprland" from your display manager
4. Enjoy your restored desktop environment!

## Manual Restoration

If you prefer manual installation:

1. Install packages based on your distro (see packages-*.txt)
2. Run the deployment script:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

## Keeping in Sync

To keep multiple machines in sync, consider:
1. Converting this to a git repository
2. Pushing to GitHub/GitLab
3. Pulling changes on other machines

