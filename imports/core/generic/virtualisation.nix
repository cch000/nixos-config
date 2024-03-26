{
  pkgs,
  username,
  ...
}: {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };

    libvirtd.enable = true;
    containers.cdi.dynamic.nvidia.enable = true;
  };

  # virtualisation
  security.virtualisation = {
    #  flush the L1 data cache before entering guests
    flushL1DataCache = "always";
  };

  environment.systemPackages = with pkgs; [virt-manager docker-compose];

  users.users.${username}.extraGroups = ["libvirtd"];
}
