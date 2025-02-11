#!/bin/bash

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }

# Confirm before proceeding
read -p "This will remove all dotfiles-related installations. Are you sure? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Remove symbolic links
log "Removing symbolic links..."
rm -f ~/.config/nvim
rm -f ~/.config/lazygit
rm -f ~/.config/zellij
rm -f ~/.zshrc
rm -f ~/.oh-my-zsh/custom

# Remove installed binaries
log "Removing installed binaries..."
sudo rm -f /usr/local/bin/nvim
sudo rm -f /usr/local/bin/lazygit
sudo rm -f /usr/local/bin/zellij
sudo rm -rf /opt/nvim-linux64

# Clean up Oh-My-Zsh and plugins
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Removing Oh-My-Zsh and plugins..."
    rm -rf ~/.oh-my-zsh/custom/plugins/jq
    rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autocomplete
    rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    rm -rf ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

# Remove fnm and Node.js
if [ -d "$HOME/.local/share/fnm" ]; then
    log "Removing fnm and Node.js..."
    rm -rf ~/.local/share/fnm
    sed -i '/fnm/d' ~/.zshrc
fi

# Remove pnpm
if [ -d "$HOME/.local/share/pnpm" ]; then
    log "Removing pnpm..."
    rm -rf ~/.local/share/pnpm
    rm -f ~/completion-for-pnpm.zsh
fi

# Remove installed packages
if command -v apt-get >/dev/null 2>&1; then
    log "Removing installed packages..."
    sudo apt remove -y build-essential zsh lua5.4 liblua5.4-dev luarocks
    sudo apt autoremove -y
fi

log "Cleanup complete! Please restart your terminal."
