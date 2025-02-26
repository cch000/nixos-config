{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myOptions.steam;
in {
  options.myOptions.steam = {
    enable = mkEnableOption "steam";
  };
  config = mkIf cfg.enable {
    programs.gamescope.enable = true;
    programs.steam = {
      enable = true;

      # Compatibility tools to install
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [mangohud];
  };
}
