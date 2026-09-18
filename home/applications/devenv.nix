{ pkgs-unstable, ... }: {
  home.packages = with pkgs-unstable; [
    devenv
  ];
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(devenv hook bash)"
    '';
  };
}
