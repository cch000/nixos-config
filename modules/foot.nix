{
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myOptions.foot;
in {
  options.myOptions.foot = {
    enable = mkEnableOption "foot";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.programs.foot = {
      enable = true;

      settings = {
        main = {
          font = "JetBrainsMono Nerd Font Mono:size=11";
          dpi-aware = "no";
          pad = "16x16";
        };

        mouse = {
          hide-when-typing = "yes";
        };

        colors = let
          green = "00b817";
          orange = "ff7800";
          purple = "6A329F";
        in {
          alpha = 0.8;
          foreground = orange; #Text
          background = "000000";
          regular2 = purple;
          regular4 = green;
          regular5 = purple;
          regular6 = green;
          regular7 = orange;
          bright2 = purple;
          bright4 = green;
          bright5 = purple;
          bright6 = green;
          bright7 = orange;
        };
      };
    };
  };
}
