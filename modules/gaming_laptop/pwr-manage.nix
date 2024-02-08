{
  pkgs,
  lib,
  ...
}: let
  pwrprofilecycle = pkgs.writeShellApplication {
    name = "pwrprofilecycle";
    text = builtins.readFile ./pwr-manage.sh;
    runtimeInputs = with pkgs; [power-profiles-daemon inotify-tools toybox];
  };

  unplug = ''ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${lib.getExe pwrprofilecycle}"'';
  plug = ''ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${lib.getExe pwrprofilecycle}"'';
in {
  services.udev.extraRules = lib.strings.concatLines [unplug plug];
}
