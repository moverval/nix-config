{ config, pkgs, ... }:
let
  # bangs = pkgs.fetchurl {
  #   url = "https://duckduckgo.com/bang.js";
  #   sha256 = "sha256-5pU21R5vMG8+AGOvDYiGJxO/jXB1rvyOyF24h3k1V2g=";
  # };
  bangs = ../dotfiles/cosmic/bangs/db.json;
  pop-launcher-ddg-bangs = pkgs.rustPlatform.buildRustPackage rec {
    pname = "pop-launcher-plugin-duckduckgo-bangs";
    version = "unstable-2024-03-24";

    src = pkgs.fetchFromGitHub {
      owner = "foo-dogsquared";
      repo = "pop-launcher-plugin-duckduckgo-bangs";
      rev = "master";
      sha256 = "sha256-RddxnoFKe7Ht+LICMdNi2GeOp95n1hSTIfc3/q+pyyo=";
    };

    cargoHash = "sha256-YTxpwvou1CUduhCtFY7DS0qEG/+zQc+kaik3FVVCrSY=";

    postInstall = ''
      mkdir -p $out/share/pop-launcher/plugins/bangs

      cp $out/bin/bangs $out/share/pop-launcher/plugins/bangs/
      cp ${bangs} $out/share/pop-launcher/plugins/bangs/db.json

      ln -s ${src}/src/plugin.ron $out/share/pop-launcher/plugins/bangs/
    '';
  };
in
{
  home.packages = [
    pop-launcher-ddg-bangs
  ];

  home.file.".local/share/pop-launcher/plugins/bangs" = {
    source = "${pop-launcher-ddg-bangs}/share/pop-launcher/plugins/bangs";
    recursive = true;
  };
}
