{ pkgs, user, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = false;
      package = pkgs.qemu_kvm;
    };
  };

  users.users."${user.name}".extraGroups = [
    "libvirtd"
    "qemu-libvirtd"
  ];

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerSocket.enable = true;
  };

 }
