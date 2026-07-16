{ pkgs, ... }: {
  home.packages = [
    pkgs.virt-manager
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///session"];
      uris = ["qemu:///session"];
    };
  };
}
