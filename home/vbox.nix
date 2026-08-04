{
  inputs,
  pkgs,
  location,
  package,
}:
let
  mkNixPak = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };
  vbox = mkNixPak {
    config = { sloth, ... }: {
      app.package = package;
      bubblewrap = {
        network = true;
        sockets = {
          x11 = true;
          wayland = true;
          pulse = true;
        };

        bind = {
          rw = [
            location
            "/run"
            "/tmp"
          ];

          ro = [
            # System-Grundlagen
            "/nix"
            "/usr"
            "/etc"
            "/sys"
            "/proc"
            "/var"
          ];

          dev = [
            "/dev"
          ];
        };

        tmpfs = [
        ];

        env = {
          "HOME" = location;
          "XDG_DATA_HOME" = "${location}/.local/share";
          "XDG_CONFIG_HOME" = "${location}/.config";
        };
      };
    };
  };
in
vbox.config.script
