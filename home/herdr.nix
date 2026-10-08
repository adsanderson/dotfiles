{ config, lib, pkgs, ... }:
let
  dotfilesRoot = "${config.home.homeDirectory}/dotfiles";
  autoTitle = pkgs.buildGoModule rec {
    pname = "herdr-auto-title";
    version = "0.13.0";

    src = pkgs.fetchFromGitHub {
      owner = "kryptamine";
      repo = "herdr-auto-title";
      rev = "v${version}";
      hash = "sha256-K/Pzekm5Jcv9AWNYBzFsFivPvK2DR04n5fOP1k93SUY=";
    };

    vendorHash = "sha256-QxFp1b7pf7bn3Hh0hyaj8ke5Z61N+WwjhHt3pFiapTs=";

    postInstall = ''
      install -Dm644 herdr-plugin.toml "$out/herdr-plugin.toml"
      mv "$out/bin/herdr-auto-title" "$out/herdr-auto-title"
      rmdir "$out/bin"
    '';
  };
in {
  xdg.configFile."herdr-auto-title/config.env".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/config/herdr-auto-title/config.env";

  home.activation.herdrAutoTitle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.herdr}/bin/herdr plugin link ${autoTitle} --enabled >/dev/null
  '';
}
