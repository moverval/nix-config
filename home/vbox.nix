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

        bind = {
          rw = [
            location
            "/run"
          ];

          ro = [
            # System-Grundlagen
            "/nix"
            "/usr"
            "/etc"
            "/sys"
            "/tmp/.X11-unix"
            "/proc"
          ];

          dev = [
            "/dev"
          ];
        };

        tmpfs = [
          "/tmp"
          "/var"
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
