{
  pkgs,
  lib,
  username,
  ...
}: {
  virtualisation = {
    podman = {
      enable = true;
    };

    docker = {
      enable = true;
      #rootless = {
      #  enable = true;
      #  setSocketVariable = true;
      #};
      storageDriver = "btrfs";
    };

    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
    };
  };
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = ["virbr0" "br0"];

  # do not start docker on boot
  # note that it can still be activated by its socket
  systemd.services.docker.wantedBy = lib.mkForce [];
  # also do not start on boot
  systemd.services.libvirtd.wantedBy = lib.mkForce [];
  systemd.services.libvirt-guests.wantedBy = lib.mkForce [];

  security.virtualisation = {
    #  flush the L1 data cache before entering guests
    flushL1DataCache = "always";
  };

  environment.systemPackages = with pkgs; [docker-compose];

  users.users.${username}.extraGroups = ["libvirtd" "docker"];
}
