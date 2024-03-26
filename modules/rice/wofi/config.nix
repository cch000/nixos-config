{
  username,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.myOptions.rice;
in {
  config = mkIf cfg.enable {
    home-manager.users.${username}.programs.wofi = {
      enable = true;
      style = builtins.readFile ./style.css;
    };
  };
}
