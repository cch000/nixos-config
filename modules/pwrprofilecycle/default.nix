{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  pwrprofilecycle = pkgs.writeShellApplication {
    name = "pwrprofilecycle";
    text = builtins.readFile ./pwrprofilecycle.sh;
    runtimeInputs = with pkgs; [coreutils power-profiles-daemon];
  };
in {
  options = {
    pwrprofilecycle = mkOption {
      type = types.package;
      description = "power profiles integration";
    };
  };

  config = {
    inherit pwrprofilecycle;
  };
}
