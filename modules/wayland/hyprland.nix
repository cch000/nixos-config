{pkgs, ...}: {
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  environment = {
    systemPackages = with pkgs; [wofi brightnessctl hyprpaper];
    variables = {
      GDK_SCALE = "2";
    };
    sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
