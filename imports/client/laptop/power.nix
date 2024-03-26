{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.power-cap-rs.nixosModules.pwr-cap-rs
  ];

  services = {
    pwr-cap-rs = {
      enable = true;
      stapm-limit = 7000;
      fast-limit = 7000;
      slow-limit = 7000;
      onlyOnBattery = true;
    };
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
    switcherooControl.enable = true;
    power-profiles-daemon.enable = true;
    udev.extraRules = let
      pwr-manage = pkgs.writeShellApplication {
        name = "pwr-manage";
        text = builtins.readFile ./pwr-manage.sh;
        runtimeInputs = with pkgs; [power-profiles-daemon toybox];
      };

      unplug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${lib.getExe pwr-manage}"'';
      plug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${lib.getExe pwr-manage}"'';
    in
      lib.strings.concatLines [unplug plug];
  };

  powerManagement.cpuFreqGovernor = "conservative";
}
