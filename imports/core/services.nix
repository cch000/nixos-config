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
        ExecStart = "/bin/sh -c 'echo 10 > /sys/fs/btrfs/566d65d0-c4f4-4e73-a8fb-71222a5fa88d/allocation/data/bg_reclaim_threshold'";
      };

      wantedBy = ["multi-user.target"];
    };
  };

  services = {
    btrfs.autoScrub = {
      interval = "weekly";
      enable = true;
    };
    fstrim.enable = true;
    fwupd.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
}
