{ config, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  outOfStore = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/${path}";
in {
  xdg.configFile = {
    "niri".source = outOfStore "config/niri";
    "noctalia".source = outOfStore "config/noctalia";
  };
}
