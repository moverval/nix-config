{
  pkgs,
  lib,
  config,
  ...
}:
{
  # https://devenv.sh/languages/
  languages = {
    nix = {
      enable = true;
      lsp.package = pkgs.nil;
    };
  };

  # Install nixd alongside nil so either language server is available in the shell.
  packages = [
    pkgs.nixd
  ];

  # See full reference at https://devenv.sh/reference/options/
}
