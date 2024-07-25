{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myOptions.niri;
  inherit (lib) mkEnableOption mkIf;
in {
  options.myOptions.niri = {
    enable = mkEnableOption "niri wm";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.niri
    ];

    systemd.user.targets.niri = {
      enable = true;
      name = "niri.target";
    };
  };
}
