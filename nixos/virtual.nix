{ user, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu.runAsRoot = false;
  };

  users.users."${user.name}".extraGroups = [
    "libvirtd"
    "qemu-libvirtd"
  ];
}
