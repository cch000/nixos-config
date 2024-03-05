{
  pkgs,
  lib,
  ...
}: let
  pwr-manage = pkgs.writeShellApplication {
    name = "pwr-manage";
    text = builtins.readFile ./pwr-manage.sh;
    runtimeInputs = with pkgs; [power-profiles-daemon toybox];
  };

  unplug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${lib.getExe pwr-manage}"'';
  plug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${lib.getExe pwr-manage}"'';
in {
  services.udev.extraRules = lib.strings.concatLines [unplug plug];
}
