{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = false;

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=passive"
      "quiet"
    ];
    # For gaming
    kernel.sysctl."vm.max_map_count" = 2147483642;
  };
}
