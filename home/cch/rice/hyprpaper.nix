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
    Unit = {
      Description = "Hyprland wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.hyprpaper}";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
