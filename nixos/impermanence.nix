{ inputs, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/libvirt"
      "/var/lib/containers"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/passwd"
      "/etc/group"
      "/etc/shadow"
      "/etc/subuid"
      "/etc/subgid"
    ];
  };
}
