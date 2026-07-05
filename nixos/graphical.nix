{ ... }: {
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.enable = true;

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;

  services.xserver.xkb = {
    layout = "eu";
    variant = "";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
}
