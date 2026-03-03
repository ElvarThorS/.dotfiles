# Dotfiles

My dotfiles repository for synchronizing and versioning my Linux desktop configuration across machines.

## What's Included

- Hyprland - Wayland compositor/window manager
- Neovim - Text editor
- Ghostty - Terminal emulator
- Kitty - Terminal emulator
- Alacritty - Terminal emulator
- Waybar - Status bar
- Mako - Notification daemon
- Fcitx5 - Input method framework
- Git - Configuration
- Starship - Shell prompt
- Omarchy - Theming system for Hyprland
- btop, lazydocker, lazygit - TUI tools

## Management with omadot

This repo uses [omadot](https://github.com/tomhayes/omadot), a GNU Stow wrapper designed for managing dotfiles with an opinionated, package-based approach.

Important: `omadot` is not preinstalled on Omarchy by default, so install it first on a new machine.

### Installation

```bash
# Install omadot
curl -fsSL https://raw.githubusercontent.com/tomhayes/omadot/main/install.sh | bash

# Install GNU Stow
sudo pacman -S stow  # Arch
sudo apt install stow  # Debian/Ubuntu
```

### Usage

```bash
# Stow all dotfiles (creates symlinks)
omadot put --all

# List managed packages
omadot list

# Add a new config
omadot get <package>
omadot put <package>

# Remove a config from management
stow -D <package>
```

### Directory Structure

The repo follows omadot's package structure:

```
.dotfiles/
├── hypr/
│   └── .config/hypr/
├── nvim/
│   └── .config/nvim/
├── ghostty/
│   └── .config/ghostty/
├── bashrc/
│   └── .bashrc
└── ...
```

When stowed, omadot creates symlinks: ~/.config/hypr -> ~/.dotfiles/hypr/.config/hypr

## Omarchy

[Omarchy](https://omarchy.org/) provides default configurations and theming for Hyprland. This dotfiles repo includes:

- Custom themes in omarchy/.config/omarchy/themes/
- Theme-specific overrides in individual app configs
- Hyprland bindings and settings that extend omarchy defaults

## Installation on New Machine

```bash
# 1. Install prerequisites and omadot
sudo pacman -S --needed git stow curl
curl -fsSL https://raw.githubusercontent.com/tomhayes/omadot/main/install.sh | bash

# If omadot is not in PATH yet, open a new shell or source your shell rc.

# 2. Clone dotfiles
git clone https://github.com/ElvarThorS/.dotfiles.git ~/.dotfiles

# 3. Stow all packages
cd ~/.dotfiles
omadot put --all

# 4. Initialize theme-generated files
omarchy-theme-set "<theme-name>"

# 5. Restart components that need it
omarchy-restart-waybar
```
