{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  imports = [
    ./config.nix
    ./hyprpaper.nix
  ];
  options.myOptions.hyprland = {
    enable = mkEnableOption "hyprland";
  };
}
