{
  description = "Nixos configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    nixosSystem = { hwConfig }: nixpkgs.lib.nixosSystem {
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

  };
}
