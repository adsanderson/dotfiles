#!/bin/bash

# Create dotfiles directory
mkdir -p ~/dotfiles

# Backup and symlink Neovim config
echo "Setting up Neovim config..."
mkdir -p ~/dotfiles/.config/nvim
cp -r ~/.config/nvim/* ~/dotfiles/.config/nvim/
rm -rf ~/.config/nvim
ln -s ~/dotfiles/.config/nvim ~/.config/nvim

# Backup and symlink Zsh configuration
echo "Setting up Zsh config..."
cp ~/.zshrc ~/dotfiles/.zshrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc

# Backup and symlink Oh-My-Zsh custom configurations
echo "Setting up Oh-My-Zsh custom configurations..."
mkdir -p ~/dotfiles/.oh-my-zsh/custom
cp -r ~/.oh-my-zsh/custom/* ~/dotfiles/.oh-my-zsh/custom/
rm -rf ~/.oh-my-zsh/custom
ln -s ~/dotfiles/.oh-my-zsh/custom ~/.oh-my-zsh/custom

# Backup and symlink Lazygit config
echo "Setting up Lazygit config..."
mkdir -p ~/dotfiles/.config/lazygit
cp -r ~/.config/lazygit/* ~/dotfiles/.config/lazygit/
rm -rf ~/.config/lazygit
ln -s ~/dotfiles/.config/lazygit ~/.config/lazygit

# Backup and symlink Zellij config
echo "Setting up Zellij config..."
mkdir -p ~/dotfiles/.config/zellij
cp -r ~/.config/zellij/* ~/dotfiles/.config/zellij/
rm -rf ~/.config/zellij
ln -s ~/dotfiles/.config/zellij ~/.config/zellij

# Create installation script
cat > ~/dotfiles/install.sh << 'EOF'
#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y zsh neovim git curl

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz

# Install Zellij
cargo install zellij

# Create symbolic links
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/lazygit ~/.config/lazygit
ln -sf ~/dotfiles/.config/zellij ~/.config/zellij
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.oh-my-zsh/custom ~/.oh-my-zsh/custom

# Set Zsh as default shell
chsh -s $(which zsh)

echo "Installation complete! Please restart your terminal."
EOF

chmod +x ~/dotfiles/install.sh

# Create README
cat > ~/dotfiles/README.md << 'EOF'
# Dotfiles

Personal configuration files for development environment.

## Components
- Neovim with LazyVim
- Zsh with Oh-My-Zsh
- Lazygit
- Zellij

## Installation

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/dotfiles
   ./install.sh
   ```

3. Restart your terminal

## Manual Configuration Required
1. Set up any SSH keys needed for Git
2. Configure Git user information:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
EOF