{lib, ...}: {
  # DISABLE once and for all this useless and annoying service
  systemd.services = {
    NetworkManager-wait-online.enable = lib.mkForce false;
    systemd-networkd-wait-online.enable = lib.mkForce false;

    set-bg_reclaim_threshold = {
      description = "enable automatic block group reclaim on sysfs";

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "/bin/sh -c 'echo 10 > /sys/fs/btrfs/50503012-89a6-47cc-bed6-821e657cf00f/allocation/data/bg_reclaim_threshold'";
      };

      wantedBy = ["multi-user.target"];
    };
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
