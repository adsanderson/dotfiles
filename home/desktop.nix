{ config, pkgs, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  outOfStore = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/${path}";
  whatsappIcon = pkgs.fetchurl {
    url = "https://web.whatsapp.com/whatsapp_pwa_icon_512.png";
    hash = "sha256-Sk6DZGzZgLKDbK6YydeXVyM4izVFH1wIEuuhqM4ztw4=";
  };
in {
  # Use Arch's package-provided ssh-agent socket; enabling it remains machine-local.
  home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";

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

  xdg.desktopEntries.whatsapp = {
    name = "WhatsApp";
    genericName = "Messaging";
    comment = "Send and receive WhatsApp messages";
    exec = "chromium --app=https://web.whatsapp.com/";
    icon = "${whatsappIcon}";
    terminal = false;
    categories = [ "Network" "InstantMessaging" ];
    startupNotify = true;
  };
}
