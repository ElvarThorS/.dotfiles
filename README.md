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

- Custom theme in omarchy/.config/omarchy/current/theme/
- Theme-specific overrides in individual app configs
- Hyprland bindings and settings that extend omarchy defaults

## Installation on New Machine

```bash
# 1. Install omadot and stow
curl -fsSL https://raw.githubusercontent.com/tomhayes/omadot/main/install.sh | bash
sudo pacman -S stow

# 2. Clone dotfiles
git clone https://github.com/ElvarThorS/.dotfiles.git ~/.dotfiles

# 3. Stow all packages
cd ~/.dotfiles
omadot put --all
```
