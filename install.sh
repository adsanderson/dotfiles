#!/bin/bash

set -euo pipefail

# Version variables
NVIM_VERSION="stable"
ZELLIJ_VERSION="v0.41.1"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1" >&2; exit 1; }

# Check if running on Debian/Ubuntu
if ! command -v apt-get >/dev/null 2>&1; then
    error "This script requires apt-get. Only Debian/Ubuntu are supported."
fi

# Create necessary directories
log "Creating directories..."
mkdir -p ~/.config ~/.local/bin

# Install required packages
log "Installing required packages..."
sudo apt update || error "Failed to update package list"
sudo apt install -y build-essential zsh git curl ripgrep fd-find fzf lua5.4 liblua5.4-dev luarocks || error "Failed to install packages"

# Install fnm if not already installed
if ! command -v fnm >/dev/null 2>&1; then
    log "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash || error "Failed to install fnm"
fi

# Install Oh-My-Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || error "Failed to install Oh-My-Zsh"
fi

# Install Neovim
if ! command -v nvim >/dev/null 2>&1; then
    log "Installing Neovim..."
    wget -q "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz" || error "Failed to download Neovim"
    sudo tar xf nvim-linux64.tar.gz -C /opt/
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
fi

# Install Lazygit if not already installed
if ! command -v lazygit >/dev/null 2>&1; then
    log "Installing Lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
fi

# Install Zellij if not already installed
if ! command -v zellij >/dev/null 2>&1; then
    log "Installing Zellij..."
    wget -q "https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/zellij-x86_64-unknown-linux-musl.tar.gz"
    tar xf zellij-x86_64-unknown-linux-musl.tar.gz
    sudo install zellij /usr/local/bin/
    rm zellij-x86_64-unknown-linux-musl.tar.gz zellij
fi

# Setup Node.js environment
if [ -d "$HOME/.local/share/fnm" ]; then
    log "Setting up Node.js environment..."
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env --use-on-cd)"
    fnm install --lts || error "Failed to install Node.js LTS"
    npm install -g neovim || error "Failed to install neovim npm package"
    
    # Install pnpm if not already installed
    if ! command -v pnpm >/dev/null 2>&1; then
        curl -fsSL https://get.pnpm.io/install.sh | sh -
        pnpm completion zsh > ~/completion-for-pnpm.zsh
    fi
fi

# Create symbolic links
log "Creating symbolic links..."
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/lazygit ~/.config/lazygit
ln -sf ~/dotfiles/.config/zellij ~/.config/zellij
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.oh-my-zsh/custom ~/.oh-my-zsh/custom

# Install Oh-My-Zsh plugins
log "Installing Oh-My-Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A plugins=(
    ["jq"]="https://github.com/reegnz/jq-zsh-plugin.git"
    ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

for plugin in "${!plugins[@]}"; do
    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
        git clone "${plugins[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin" || error "Failed to install $plugin"
    fi
done

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    log "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

log "Installation complete! Please restart your terminal."
