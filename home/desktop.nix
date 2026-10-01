{ config, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  outOfStore = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/${path}";
in {
  home.file.".local/bin/kvm-toggle".source = outOfStore "bin/kvm-toggle";
  home.file.".XCompose".source = outOfStore "config/xcompose/XCompose";


  xdg.configFile = {
    "alacritty".source = outOfStore "config/alacritty";
    "foot".source = outOfStore "config/foot";
  };
}
