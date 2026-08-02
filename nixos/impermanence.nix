{ inputs, pkgs, lib, ... }: {
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
    ];
  };

  virtualisation.vmVariant = {
    environment.persistence."/persist".files = lib.mkForce [
      "/etc/machine-id"
    ];
    systemd.services.clean-etc-for-impermanence.enable = lib.mkForce false;
  };

  # Workaround for systemd-based initrd: NixOS activation creates /etc/passwd etc. in early boot,
  # which blocks the impermanence symlinking/mounting services because the files already exist.
  # We delete them if they are regular files (not symlinks) right before the impermanence services run.
  systemd.services.clean-etc-for-impermanence = {
    description = "Clean up /etc/passwd and friends to allow impermanence to mount them";
    before = [
      "persist-persist-etc-passwd.service"
      "persist-persist-etc-group.service"
      "persist-persist-etc-shadow.service"
    ];
    wantedBy = [
      "persist-persist-etc-passwd.service"
      "persist-persist-etc-group.service"
      "persist-persist-etc-shadow.service"
    ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "clean-etc-for-impermanence" ''
        for f in /etc/passwd /etc/group /etc/shadow; do
          if [ -f "$f" ] && [ ! -L "$f" ]; then
            echo "Removing existing $f to allow impermanence to link it"
            rm -f "$f"
          fi
        done
      '';
    };
  };
}
