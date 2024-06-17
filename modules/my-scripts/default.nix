{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  inherit
    (pkgs)
    power-profiles-daemon
    toybox
    supergfxctl
    ;

  mkScript = name: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile ./${name}.sh;
    };

  pwrprofilecycle = mkScript "pwrprofilecycle" [
    power-profiles-daemon
  ];

  pwr-manage = mkScript "pwr-manage" [
    power-profiles-daemon
    toybox
  ];

  auto-profile = mkScript "auto-profile" [
    toybox
    power-profiles-daemon
    supergfxctl
  ];
in {
  options.myScripts = {
    pwrprofilecycle = mkOption {
      type = types.package;
      description = "power profiles integration";
    };
    pwr-manage = mkOption {
      type = types.package;
      description = "power tweaks on plug/unplug";
    };
    auto-profile = mkOption {
      type = types.package;
      description = "auto power profile selection";
    };
  };

  config.myScripts = {
    inherit
      pwrprofilecycle
      pwr-manage
      auto-profile
      ;
  };
}
