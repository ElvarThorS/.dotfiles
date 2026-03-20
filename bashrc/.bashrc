# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

unalias c 2>/dev/null
c() {
  systemd-run --user --pty \
    -p MemoryHigh=8G \
    -p MemoryMax=12G \
    -p MemorySwapMax=0 \
    -p CPUQuota=300% \
    -- opencode "$@"
}

export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"

lzd-local() {
  DOCKER_CONTEXT=default lazydocker "$@"
}

lzd-home() {
  if ! ssh-add -l >/dev/null 2>&1; then
    ssh-add ~/.ssh/id_ed25519 || return 1
  fi

  ssh -t elvar@192.168.0.12 'cd /docker/servarr && ~/.local/bin/lazydocker'
}

vhomelab() {
  local mount_dir="$HOME/mnt/homelab-root"
  local remote_path="/"

  if (( $# > 0 )); then
    remote_path="$1"
  fi

  if [[ $remote_path != /* ]]; then
    remote_path="/$remote_path"
  fi

  if ! command -v sshfs >/dev/null 2>&1; then
    echo "sshfs is not installed. Install it with: omarchy-pkg-add sshfs"
    return 1
  fi

  if ! ssh-add -l >/dev/null 2>&1; then
    ssh-add ~/.ssh/id_ed25519 || return 1
  fi

  mkdir -p "$mount_dir"

  if ! mountpoint -q "$mount_dir"; then
    sshfs homelab:/ "$mount_dir" -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 || return 1
  fi

  nvim "$mount_dir$remote_path"
  local nvim_status=$?

  if ! fusermount -u "$mount_dir" >/dev/null 2>&1; then
    fusermount -uz "$mount_dir" >/dev/null 2>&1
  fi

  return $nvim_status
}

alias vh='vhomelab'

alias alacarchy='bash <(curl -fsSL https://raw.githubusercontent.com/DanielCoffey1/a-la-carchy/master/a-la-carchy.sh)'
