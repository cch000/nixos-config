{
  pkgs,
  lib,
  config,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myOptions.defaultPrograms;
in {
  options.myOptions.defaultPrograms = {
    enable = mkEnableOption "default programs";
  };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      silent = true;
      # faster, permanent implementation of use_nix and use_flake
      nix-direnv.enable = true;
    };

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        #terminal stuff
        htop
        neofetch
        powerline-fonts
        wl-clipboard
        tree
        killall
        zip
        unzip

        #gui
        evince
        gnome.eog
        gnome3.gnome-tweaks
        gnome.nautilus
        gnome.gnome-calendar
        gimp
        tor-browser-bundle-bin
        fragments
        celluloid
        pavucontrol
        webcord-vencord
        spotify
        vorta
        mgba
        zed-editor
        freetube
      ];

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs #For screen capture in Hyprland
        ];
      };
    };
  };
}
