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
alias alacarchy='bash <(curl -fsSL https://raw.githubusercontent.com/DanielCoffey1/a-la-carchy/master/a-la-carchy.sh)'
