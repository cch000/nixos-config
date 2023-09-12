{pkgs, ...}: {
  imports = [
    ./pwr-manage.nix
    ./ryzenadj.nix
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
    switcherooControl.enable = true;
  };

  powerManagement.cpuFreqGovernor = "conservative";

  environment.systemPackages = with pkgs; [inotify-tools ryzenadj];
}
