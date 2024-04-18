{
  username,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.myOptions.wofi;
in {
  options.myOptions.wofi = {
    enable = mkEnableOption "wofi";
  };
  config = mkIf cfg.enable {
    home-manager.users.${username}.programs.wofi = {
      enable = true;
      style = builtins.readFile ./style.css;
    };
  };
}
