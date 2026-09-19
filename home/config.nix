{ config, user, ... }:
let
  dotfiles = "${user.location}/config/home/dotfiles";
in
{
  home.file.".config/gitui".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/gitui";
  home.file.".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/helix";
  home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr";
  home.file.".config/keepassxc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/keepassxc";
  home.file.".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/kitty";
  home.file.".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/quickshell";
  home.file.".config/zathura".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zathura";
  home.file.".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zellij";
  home.file.".config/television".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/television";
  home.file.".radare2rc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/radare2/radare2rc";
  home.file.".config/matugen".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/matugen";
}
