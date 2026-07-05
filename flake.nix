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
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      nixosSystem =
        { hwConfig }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system hwConfig; };

          modules = [
            ./nixos/configuration.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        main = nixosSystem {
          hwConfig = ./nixos/hardware/main.nix;
        };
      };

      homeConfigurations."moritz" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit inputs;
        };

        modules = [
          ./nixos/home.nix
        ];
      };
    };
}
