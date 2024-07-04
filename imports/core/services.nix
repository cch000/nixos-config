{lib, ...}: {
  # DISABLE once and for all this useless and annoying service
  systemd.services = {
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;
  };

  services = {
    btrfs.autoScrub.enable = true;

    fstrim.enable = true;

    fwupd.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
