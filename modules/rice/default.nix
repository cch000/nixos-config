{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.myOptions.rice = {
    enable = mkEnableOption "the whole rice";
  };
  imports = [
    ./hyprland
    ./waybar
    ./wofi
    ./rice-services.nix
    ./theme.nix
  ];
}
