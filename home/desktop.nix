{ config, pkgs, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  outOfStore = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/${path}";
in {
  home.file.".local/bin/kvm-toggle".source = outOfStore "bin/kvm-toggle";
  home.file.".XCompose".source = outOfStore "config/xcompose/XCompose";

  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "JetBrainsMono Nerd Font" ];
      serif = [ "JetBrainsMono Nerd Font" ];
    };
  };

  xdg.configFile = {
    "alacritty".source = outOfStore "config/alacritty";
    "foot".source = outOfStore "config/foot";
  };
}
