{
  description = "Nixos configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpak.url = "github:nixpak/nixpak/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = {
        name = "moritz";
        comment = "Moritz";
        location = "/home/moritz";
      };
      homeConfig = {
        inherit pkgs;

        extraSpecialArgs = {
          inherit inputs user;
        };

        modules = [
          ./home/home.nix
          ./home/applications/profiles/all.nix
        ];
      };
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      nixosSystem =
        {
          modules,
          user,
          homeModules,
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              system
              user
              ;
            homeModules = homeModules;
          };

          modules = modules;
        };
    in
    {
      nixosConfigurations = {
        default = nixosSystem {
          user = user;
          modules = [
            ./nixos/default.nix
            ./nixos/graphical.nix
            ./nixos/sound.nix
            ./nixos/locale.nix
          ];
          homeModules = homeConfig.modules;
        };
      };

      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration homeConfig;
      };
    };
}
