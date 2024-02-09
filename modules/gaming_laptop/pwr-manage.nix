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

  unplug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${lib.getExe pwrprofilecycle}"'';
  plug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${lib.getExe pwrprofilecycle}"'';
in {
  services.udev.extraRules = lib.strings.concatLines [unplug plug];
}
