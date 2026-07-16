# NixOS Configuration

This config can be installed via one command on every system.

```sh
sudo nixos-rebuild switch --flake github:moverval/nix-config/main#default --impure
```

# Home Manager Configuration

If the NixOS Configuration is unchanged, there exists a shortcut, so no sudo and less time is required when updating.

```sh
home-manager switch --flake github:moverval/nig-config/main#default
```

# Change Username

The user configuration can be updated in `flake.nix`.
