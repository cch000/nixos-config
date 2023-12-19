{
  pkgs,
  lib,
  ...
}: {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${./wall.png}
    wallpaper = , ${./wall.png}
  '';

  systemd.user.services.hyprpaper = {
    Service = {
      ExecStart = "${lib.getExe pkgs.hyprpaper}";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
