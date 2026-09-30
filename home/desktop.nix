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
    "hypr/hyprland.lua".source = outOfStore "config/hypr/hyprland.lua";
    "hypr/autostart.lua".source = outOfStore "config/hypr/autostart.lua";
    "hypr/bindings.lua".source = outOfStore "config/hypr/bindings.lua";
    "hypr/input.lua".source = outOfStore "config/hypr/input.lua";
    "hypr/looknfeel.lua".source = outOfStore "config/hypr/looknfeel.lua";
    "hypr/monitors.lua".source = outOfStore "config/hypr/monitors.lua";
    "omarchy/shell.json".source = outOfStore "config/omarchy/shell.json";
    "omarchy/shell.toml".source = outOfStore "config/omarchy/shell.toml";
  };
}
