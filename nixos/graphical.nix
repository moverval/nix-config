{ inputs, system, pkgs, ... }: {
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.enable = false;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Launches a clean terminal login prompt that safely hands over control to UWSM
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'start-hyprland'";
        user = "greeter";
      };
    };
  };

  # Prevent the greeter user from failing permissions on real graphics cards
  users.users.greeter.extraGroups = [ "video" "render" ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.quickshell.packages.${system}.default
    awww
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
