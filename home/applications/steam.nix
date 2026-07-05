{
  inputs,
  pkgs,
  user,
  ...
}:
let
  vpackage = import ../vbox.nix {
    inherit inputs pkgs;
    location = "${user.location}/volumes/steam";
    package = pkgs.steam;
  };
in
inputs.nixpkgs.lib.recursiveUpdate
  (import ../desktopApplication.nix {
    pkg = vpackage;
    exec = "/bin/steam %U";
    name = "Steam";
    comment = "Steam on volumes/steam";
    icon = "${pkgs.steam}/share/icons/hicolor/256x256/apps/steam.png";
    categories = [ "Game" ];
  })
  ({
    home.file."volumes/steam/.exists".text = "";
  })
