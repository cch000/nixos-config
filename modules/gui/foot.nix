{
  config,
  lib,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myOptions.gui.foot;
in {
  options.myOptions.gui.foot = {
    enable = mkEnableOption "foot";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.programs.foot = {
      enable = true;

      settings = {
        main = {
          font = "JetBrainsMono Nerd Font Mono:size=10";
          dpi-aware = "yes";
          pad = "16x16";
        };

        mouse = {
          hide-when-typing = "yes";
        };

        colors = rec {
          alpha = 0.8;
          #comments are original colors
          foreground = "ff7800"; #Text
          background = "000000";
          regular2 = "6A329F"; # Green
          regular4 = "00b817"; # Blue
          regular6 = "00b817"; # teal
          bright2 = "${regular2}";
          bright4 = "${regular4}";
          bright6 = "${regular6}";
        };
      };
    };
  };
}
