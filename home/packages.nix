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
    jq
    lazygit
    mise
    neovim
    ripgrep
    starship
    tmux
    unzip
    zoxide
  ];
}
