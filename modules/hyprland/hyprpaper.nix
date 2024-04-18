{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  inherit (lib) mkIf getExe;
  cfg = config.myOptions.hyprland;
in {
  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [pkgs.hyprpaper];
      xdg.configFile."hypr/hyprpaper.conf".text = ''
        splash = false
        preload = ${./wall.png}
        wallpaper = , ${./wall.png}
      '';

      systemd.user.services.hyprpaper = {
        Service = {
          ExecStart = "${getExe pkgs.hyprpaper}";
        };
        Install.WantedBy = ["hyprland-session.target"];
      };
    };
  };
}
