{ pkgs-unstable, ... }: {
  imports = [
    ./base.nix
    # Steam with sandboxing
    ../steam.nix
    ../heroic.nix
    # Virtual machine interface
    ../virt-manager.nix
    # Development
    ../devenv.nix
    # Isolate Folder Script
    ../isolate.nix
    # Custom shell config
    ../nushell.nix
  ];

  programs.zoxide = {
    enable = true;
  };

  # Each base package should have a reason why it stands here
  home.packages = with pkgs-unstable; [
    # For writing pdfs
    typst
    # Language server for writing pdfs
    tinymist
    # For reading pdfs
    zathura

    # Convert video and audio
    ffmpeg

    # Calculator
    julia

    # Recording
    obs-studio

    # Screenshot
    grim
    slurp
    swappy
    wl-clipboard

    # Terminal manager
    zellij

    # Game compositor
    gamescope

    # Music!
    cliamp

    # For all fuzzy finder
    television
    fd
    bat

    # Dynamic Theming
    matugen

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    #
    (import ../../../extra/ai/default.nix { inherit pkgs; })
  ];

  programs.bash = {
    bashrcExtra = ''
      function ipi() {
        i --pi -c "pi $@"
      }
    '';
  };
}
