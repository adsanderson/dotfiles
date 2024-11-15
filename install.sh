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
wget https://github.com/zellij-org/zellij/releases/download/v0.41.1/zellij-x86_64-unknown-linux-musl.tar.gz
tar -xvf zellij-x86_64-unknown-linux-musl.tar.gz
rm zellij-x86_64-unknown-linux-musl.tar.gz

mkdir -p ~/.config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/lazygit
mkdir -p ~/.config/zellij

# Create symbolic links
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/lazygit ~/.config/lazygit
ln -sf ~/dotfiles/.config/zellij ~/.config/zellij
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.oh-my-zsh/custom ~/.oh-my-zsh/custom

# Set Zsh as default shell
chsh -s $(which zsh)

if [ ! -d "~/.oh-my-zsh/custom/plugins/jq" ] then
  git clone https://github.com/reegnz/jq-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/jq
fi
if [ ! -d "~/.oh-my-zsh/custom/plugins/zsh-autocomplete" ] then
  git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
fi
if [ ! -d "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
if [ ! -d "~/.oh-my-zsh/custom/themes/powerlevel10k" ] then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo "Installation complete! Please restart your terminal."
