{
  description = "Portable development environment for laptop, WSL, and servers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkHome = username: modules: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username; };
        inherit modules;
      };
      homeConfigurations = {
        laptop = mkHome "adams" [ ./home/common.nix ./home/desktop.nix ];
        work-wsl = mkHome "adams" [ ./home/common.nix ./home/wsl.nix ];
        server = mkHome "adams" [ ./home/common.nix ./home/server.nix ];
      };
    in {
      packages.${system}.home-manager = home-manager.packages.${system}.default;
      inherit homeConfigurations;
      checks.${system} = {
        laptop = homeConfigurations.laptop.activationPackage;
        work-wsl = homeConfigurations.work-wsl.activationPackage;
        server = homeConfigurations.server.activationPackage;
      };
    };
}
