{
  lib,
  username,
  ...
}: {
  virtualisation = {
    podman = {
      enable = true;
    };

    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
    };
  };
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = ["virbr0" "br0"];

  # docker impermanence
  # environment.persistence."/persist" = {
  #   directories = [
  #     "/var/lib/docker"
  #   ];
  # };

  # do not start docker on boot
  # note that it can still be activated by its socket
  # systemd.services.docker.wantedBy = lib.mkForce [];
  # also do not start on boot
  systemd.services.libvirtd.wantedBy = lib.mkForce [];
  systemd.services.libvirt-guests.wantedBy = lib.mkForce [];

  security.virtualisation = {
    #  flush the L1 data cache before entering guests
    flushL1DataCache = "always";
  };

  users.users.${username}.extraGroups = [
    "libvirtd"
    #"docker"
  ];
}
