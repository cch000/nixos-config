{pkgs, ...}: {
  imports = [
    ./pwr-manage.nix
    ./ryzenadj.nix
  ];

  programs.steam.enable = true;

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
    switcherooControl.enable = true;
  };

  powerManagement.cpuFreqGovernor = "conservative";

  environment.systemPackages = with pkgs; [inotify-tools mangohud ryzenadj];
}
