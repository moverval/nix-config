{ pkgs, ... }: {
  imports = [
    ./base.nix
    # Neovim editor with config
    ../neovim.nix
    # Steam with sandboxing
    ../steam.nix
    # Virtual machine interface
    ../virt-manager.nix
    # Development
    ../devenv.nix
    ../ddg_bangs.nix
  ];

  programs.zoxide.enable = true;

  # Each base package should have a reason why it stands here
  home.packages = with pkgs; [
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
  ];
}
