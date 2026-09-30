{ config, username, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  outOfStore = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/${path}";
in {
  imports = [ ./packages.nix ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      # Preserve upgraded tool versions until an explicit `mise prune`.
      MISE_UPGRADE_AUTO_PRUNE = "false";
      VISUAL = "nvim";
    };
  };
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    historyControl = [ "ignoreboth" ];
    historyFileSize = 32768;
    historySize = 32768;
    profileExtra = ''
      if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
    initExtra = ''
      if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
      source "${dotfilesRoot}/config/shell/bashrc"
    '';
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    history = {
      size = 32768;
      save = 32768;
    };
    profileExtra = ''
      if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
    initContent = ''
      if [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
      source "${dotfilesRoot}/config/shell/zshrc"
    '';
  };

  home.file = {
    ".gitconfig".source = outOfStore "config/git/config";
    ".inputrc" = {
      source = outOfStore "config/shell/inputrc";
      # Home Manager's backup mode intentionally excludes foreign symlinks.
      # Replacing the link is safe: its target remains untouched.
      force = true;
    };
  };

  xdg.enable = true;
  xdg.configFile = {
    "nix/nix.conf".text = "experimental-features = nix-command flakes\n";
    "btop".source = outOfStore "config/btop";
    "gh/config.yml".source = outOfStore "config/gh/config.yml";
    "opencode/opencode.json".source = outOfStore "config/opencode/opencode.json";
    "opencode/tui.json".source = outOfStore "config/opencode/tui.json";
    "herdr/config.toml".source = outOfStore "config/herdr/config.toml";
    "git/ignore".source = outOfStore "config/git/ignore";
    "mise/config.toml".source = outOfStore "config/mise/config.toml";
    "nvim".source = outOfStore "config/nvim";
    "starship.toml".source = outOfStore "config/starship/starship.toml";
    "tmux".source = outOfStore "config/tmux";
  };
}
