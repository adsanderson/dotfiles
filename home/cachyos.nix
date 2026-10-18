{ config, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  outOfStore = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/${path}";
in {
  xdg.configFile = {
    "umbriel/config.toml".source = outOfStore "config/umbriel/config.toml";
    "noctalia".source = outOfStore "config/noctalia";
  };
}
