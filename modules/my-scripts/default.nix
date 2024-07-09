{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  inherit
    (pkgs)
    power-profiles-daemon
    supergfxctl
    btdu
    coreutils
    toybox
    hyprland
    swaylock-effects
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
    coreutils
    power-profiles-daemon
    supergfxctl
  ];

  btdu-helper = mkScript "btdu-helper" [
    btdu
  ];

  lock = mkScript "lock" [
    hyprland
    swaylock-effects
    coreutils
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

    btdu-helper = mkOption {
      type = types.package;
      description = "helper script for btdu";
    };

    lock = mkOption {
      type = types.package;
      description = "lock script";
    };
  };

  config.myScripts = {
    inherit
      pwrprofilecycle
      pwr-manage
      auto-profile
      btdu-helper
      lock
      ;
  };
}
