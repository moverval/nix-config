{ inputs, pkgs, ... }:
let
  vpackage = import ../vbox.nix {
    inherit inputs pkgs;
    location = "/home/moritz/volumes/steam";
    package = pkgs.steam;
  };
in
import ../desktopApplication.nix {
  pkg = vpackage;
  exec = "/bin/steam %U";
  name = "Steam";
  comment = "Steam on volumes/steam";
  icon = "${pkgs.steam}/share/icons/hicolor/256x256/apps/steam.png";
  categories = [ "Game" ];
}
