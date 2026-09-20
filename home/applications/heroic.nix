{
  inputs,
  pkgs,
  user,
  ...
}:
let
  vpackage = import ../vbox.nix {
    inherit inputs pkgs;
    location = "${user.location}/volumes/heroic";
    package = (pkgs.heroic.override {
      extraPkgs = pkgs': with pkgs'; [
        gamescope
        gamemode
      ];
    });
  };
in
inputs.nixpkgs.lib.recursiveUpdate
  (import ../desktopApplication.nix {
    pkg = vpackage;
    exec = "/bin/heroic %U";
    name = "Heroic";
    comment = "Heroic on volumes/heroic";
    icon = "${pkgs.heroic}/share/icons/hicolor/scalable/apps/com.heroicgameslauncher.hgl.svg";
    categories = [ "Game" ];
  })
  ({
    home.file."volumes/heroic/.exists".text = "";
  })
