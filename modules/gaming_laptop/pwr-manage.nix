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
in {
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${lib.getExe pwrprofilecycle}"
    ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${lib.getExe pwrprofilecycle}"
  '';
}
