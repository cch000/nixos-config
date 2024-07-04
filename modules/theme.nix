{
  lib,
  config,
  username,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.myOptions.theme;
in {
  options.myOptions.theme = {
    enable = mkEnableOption "theme";
  };
  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];

    home-manager.users.${username} = {
      gtk = with pkgs; {
        enable = true;
        iconTheme = {
          name = "Papirus";
          package = papirus-icon-theme;
        };
        theme = {
          name = "adw-gtk3-dark";
          package = adw-gtk3;
        };
      };

      home = {
        pointerCursor = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 22;
          gtk.enable = true;
          x11.enable = true;
        };

        sessionVariables = {
          XCURSOR_SIZE = "22";
          GTK_USE_PORTAL = "1";
        };
      };
    };
  };
}
