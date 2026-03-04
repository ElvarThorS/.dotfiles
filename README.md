# Dotfiles

My dotfiles repository for synchronizing and versioning my Linux desktop configuration across machines.

## What's Included

- Hyprland - Wayland compositor/window manager
- Neovim - Text editor
- Ghostty - Terminal emulator
- Waybar - Status bar
- Mako - Notification daemon
- Fcitx5 - Input method framework
- Git - Configuration
- Tmux - Terminal multiplexer
- Starship - Shell prompt (managed by Omarchy theme hooks)
- Omarchy - Theming system for Hyprland
- Autostart entries and shell defaults

## Management with omadot

This repo uses [omadot](https://github.com/tomhayes/omadot), a GNU Stow wrapper designed for managing dotfiles with an opinionated, package-based approach.

Important: `omadot` is not preinstalled on Omarchy by default, so install it first on a new machine.

### Installation

```bash
# Install omadot
curl -fsSL https://raw.githubusercontent.com/tomhayes/omadot/main/install.sh | bash

# Install GNU Stow (Omarchy/Arch)
sudo pacman -S stow
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

For first-time setup on Omarchy, do not run `omadot put --all` immediately. Use the conflict-safe bootstrap workflow below.

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

## Theme Manager Plus (Optional)

[Theme Manager Plus](https://github.com/OldJobobo/theme-manager-plus) is a CLI/TUI that works with Omarchy and can switch:

- Omarchy theme
- Waybar theme
- Walker theme
- Hyprlock theme
- Starship theme or preset

### Install (new machine)

```bash
curl -fsSL https://raw.githubusercontent.com/OldJobobo/theme-manager-plus/master/install.sh | bash
source ~/.profile
theme-manager version
```

Pin to a known version (example: same as this setup):

```bash
THEME_MANAGER_VERSION=0.3.3 \
  curl -fsSL https://raw.githubusercontent.com/OldJobobo/theme-manager-plus/master/install.sh | bash
```

### Quick usage

```bash
theme-manager browse
theme-manager set "<theme-name>" -w -k --hyprlock
theme-manager print-config
```

### Notes

- `theme-manager` installs to `~/.local/bin/theme-manager`.
- It is intentionally not managed by stow in this repo.
- It may update files/symlinks under `~/.config/waybar`, `~/.config/walker`, `~/.config/hypr/themes/hyprlock`, and `~/.config/starship.toml`.
- Those updates are expected when using Theme Manager Plus with Omarchy.

## Installation on New Machine (Conflict-Safe)

```bash
# 1. Install prerequisites and omadot
sudo pacman -S --needed git stow curl
curl -fsSL https://raw.githubusercontent.com/tomhayes/omadot/main/install.sh | bash

# If omadot is not in PATH yet, open a new shell or source your shell rc.

# 2. Clone dotfiles
git clone https://github.com/ElvarThorS/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. Define managed packages (single stow invocation for clean conflict checks)
packages=(
  autostart
  bashrc
  fastfetch
  fcitx5
  ghostty
  git
  gtk-3.0
  gtk-4.0
  hypr
  mako
  nvim
  omarchy
  tmux
  waybar
)

# 4. Preflight conflict check (no filesystem changes)
stow -n -v -d "$HOME/.dotfiles" -t "$HOME" "${packages[@]}"

# On first run, conflict warnings are expected because Omarchy already generated
# many real files in ~/.config. We back those up in the next step.

# 5. Backup conflicting pre-generated Omarchy configs
backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup"

conflicts=(
  ".bashrc"
  ".config/autostart"
  ".config/fastfetch"
  ".config/fcitx5"
  ".config/ghostty"
  ".config/git"
  ".config/gtk-3.0"
  ".config/gtk-4.0"
  ".config/hypr"
  ".config/mako"
  ".config/nvim"
  ".config/omarchy"
  ".config/tmux"
  ".config/waybar"
)

for rel in "${conflicts[@]}"; do
  src="$HOME/$rel"
  if [[ -e "$src" || -L "$src" ]]; then
    mkdir -p "$backup/$(dirname "$rel")"
    mv "$src" "$backup/$rel"
  fi
done

echo "Backups stored in: $backup"

# 6. Re-run preflight; this should now be mostly LINK lines
stow -n -v -d "$HOME/.dotfiles" -t "$HOME" "${packages[@]}"

# 7. Apply stow links
stow -v -d "$HOME/.dotfiles" -t "$HOME" "${packages[@]}"

# 8. Initialize Omarchy-generated theme outputs
omarchy-theme-set "<theme-name>"

# 9. Restart components that need it
omarchy-restart-waybar
hyprctl reload || true
```

## Post-Install Verification

Run this after setup on a new machine to confirm core links and tools are healthy:

```bash
test -L "$HOME/.config/hypr" && echo "hypr: OK"
test -L "$HOME/.config/waybar" && echo "waybar: OK"
test -L "$HOME/.config/omarchy" && echo "omarchy: OK"
test -L "$HOME/.config/nvim" && echo "nvim: OK"
test -L "$HOME/.config/mako" && echo "mako: OK"
test -e "$HOME/.config/starship.toml" && echo "starship file: OK"

omarchy-theme-current
omarchy-theme-set "<theme-name>"
omarchy-restart-waybar

nvim --headless "+q"
tmux -V
ghostty --version

# Stow integrity checks
chkstow --target="$HOME" --badlinks
# chkstow --target="$HOME" --aliens

# Manual checks
# 1) Lock screen: omarchy-lock-screen
# 2) Waybar visible after restart
# 3) Open terminal + Neovim to confirm theme and keymaps
```

## Updating on Existing Machine

```bash
cd ~/.dotfiles
git pull

packages=(
  autostart
  bashrc
  fastfetch
  fcitx5
  ghostty
  git
  gtk-3.0
  gtk-4.0
  hypr
  mako
  nvim
  omarchy
  tmux
  waybar
)

# Restow prunes stale links and reapplies package links cleanly
stow -R -v -d "$HOME/.dotfiles" -t "$HOME" "${packages[@]}"

# Rebuild Omarchy generated outputs after updates
omarchy-theme-set "<theme-name>"
omarchy-restart-waybar
```

## Notes

- Stow is conflict-safe by default: if it finds conflicts, it aborts without partial changes.
- Avoid `stow --adopt` for normal bootstrap; it moves target files into your repo package trees.
- `omadot put --all` is convenient for routine use, but explicit `stow -n`/`stow -R` is better when validating conflicts.
- `~/.config/starship.toml` is intentionally not stowed; Omarchy theme hooks manage it.
- If you ever see `source is an absolute symlink` from stow, update your clone (`git pull`) and re-run preflight.
