{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    btop
    eza
    fd
    fzf
    gh
    git
    herdr
    jq
    lazygit
    mise
    neovim
    openssh
    ripgrep
    starship
    tmux
    unzip
    zoxide
  ];
}
