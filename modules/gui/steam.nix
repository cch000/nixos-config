{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myOptions.gui.steam;
in {
  options.myOptions.gui.steam = {
    enable = mkEnableOption "steam";
  };
  config = mkIf cfg.enable {
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
