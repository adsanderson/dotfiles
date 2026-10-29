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
    lazydocker
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
