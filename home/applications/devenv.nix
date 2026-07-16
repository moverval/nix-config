{ pkgs, ... }: {
  home.packages = with pkgs; [
    devenv
  ];
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(devenv hook bash)"
    '';
  };
}
