{lib, ...}: {
  # DISABLE once and for all this useless and annoying service
  systemd.services = {
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;
  };

  services = {
    fstrim.enable = true;
    gvfs.enable = true; # so that external devices to show up on nautilus
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
