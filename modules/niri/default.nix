{
  pkgs,
  config,
  lib,
  username,
  ...
}: let
  cfg = config.myOptions.niri;
  inherit (lib) mkEnableOption mkIf;
in {
  options.myOptions.niri = {
    enable = mkEnableOption "niri wm";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      niri
    ];
    xdg.portal = {
      enable = true;
      configPackages = [pkgs.xdg-desktop-portal-gnome];
      xdgOpenUsePortal = true;
    };

    systemd.user.targets.niri = {
      enable = true;
      name = "niri.target";
    };

    home-manager.users.${username}.home = {
      file.".config/niri/config.kdl" = {
        text = builtins.readFile ./config.kdl;
      };
    };
  };
}
