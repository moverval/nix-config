{ pkgs, ... }: {
  # Each base package should have a reason why it stands here
  home.packages = with pkgs; [
    # For development and versioning of every project
    git
    # Minimal editor
    vim
    # Internet access
    firefox
    # Password access
    keepassxc
    # Git with credentials
    git-credential-keepassxc
    # Needed for neovim and great for file searching
    ripgrep
    # Editor for just everything
    zed-editor

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
