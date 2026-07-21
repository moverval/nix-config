{ pkgs, ... }: {
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    waybar
    dunst
    libnotify
    awww
    rofi
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.xserver.xkb = {
    layout = "eu";
    variant = "";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
}
